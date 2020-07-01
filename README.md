# Sandwiches
SwiftUI 2020年WWDC演示示例

# 整体效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200701172512389.gif)
# 代码实现
## 文件目录
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200701172602489.png)
## SandwichesApp.swift
```swift
import SwiftUI

@main
struct SandwichesApp: App {
	// 定义一个私有的状态对象 store
    @StateObject private var store = SandwichStore()

    var body: some Scene {
        WindowGroup {
        	// 将store传递给列表页
            ContentView(store: store)
        }
    }
}
```

## SandwichStore.swift
将模型数据抽离出来观察其数据变化
```swift
class SandwichStore: ObservableObject {
    @Published var sandwiches: [Sandwich]
    
    init(sandwiches: [Sandwich] = [] ){
        self.sandwiches = sandwiches
    }
}

let testStore = SandwichStore(sandwiches: testData)
```

## ContentView.swift
列表效果的实现
```swift
import SwiftUI

struct ContentView: View {
// 定义一个观察对象 store
    @ObservedObject var store: SandwichStore
        
    var body: some View {
        NavigationView{
            // 列表的实现
            List {
                ForEach(store.sandwiches) { sandwich in
                    SandwichCell(sandwich: sandwich)
                }
                .onMove (perform: moveSandwiches)
                .onDelete(perform: deleteSandwiches)
                
                HStack {
                    Spacer()
                    Text("\(store.sandwiches.count) Sandwiches")
                    Spacer()
                }
            }
            .navigationTitle("Sandwiches")
//            .toolbar { // 跟发布会演示的效果不同
//                #if os(iOS)
//                EditButton()
//                #endif
//                Button("Add", action: makeSandwich)
//            }	
			// 先用旧的实现方式显示导航栏功能按键
            .navigationBarItems(leading: EditButton(),
                                trailing: Button("Add", action: makeSandwich))
            Text("Select a sandwich")
                .font(.largeTitle)
        }
        
    }

    // 添加
    func makeSandwich() {
        withAnimation {
            store.sandwiches.append(Sandwich(name: "Patty melt", ingredientCount: 3))
        }
    }
    // 移动
    func moveSandwiches(from: IndexSet, to: Int) {
        withAnimation {
            store.sandwiches.move(fromOffsets: from, toOffset: to)
        }
    }
    // 删除
    func deleteSandwiches(offsets: IndexSet) {
        withAnimation {
            store.sandwiches.remove(atOffsets: offsets)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group { // 创建了不同模式下的模拟器预览
            ContentView(store: testStore)
            ContentView(store: testStore)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            ContentView(store: testStore)
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            ContentView(store: testStore)
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))

        }
    }
}

struct SandwichCell: View {
	// 接收cell传递来的数据
    var sandwich: Sandwich
    
    var body: some View {
        NavigationLink(destination: SandwichDetail(sandwich: sandwich)){
            Image(sandwich.thumbnailName)
                .cornerRadius(8.0)
            
            VStack(alignment: .leading) {
                Text(sandwich.name)
                Text("\(sandwich.ingredientCount) ingredients")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

## Sandwich.swift
列表的模型文件
```swift
import Foundation
// 模型定义
struct Sandwich: Identifiable {
    var id = UUID()
    var name: String
    var ingredientCount: Int
    var isSpicy: Bool = false
    
    var imageName: String { return name }
    var thumbnailName: String {return name + "Thumb"}
}

// 创建一组测试数组
let testData = [
    Sandwich(name: "Club", ingredientCount: 4 , isSpicy: false),
    Sandwich(name: "Pastrami on rye", ingredientCount: 4, isSpicy: true),
    Sandwich(name: "French dip", ingredientCount: 3, isSpicy: false),
    Sandwich(name: "Bánh mi", ingredientCount: 5, isSpicy: true),
    Sandwich(name: "Ice cream sandwich", ingredientCount: 2, isSpicy: false),
    Sandwich(name: "Croque madame", ingredientCount: 4, isSpicy: false),
    Sandwich(name: "Hot dog", ingredientCount: 2, isSpicy: true),
    Sandwich(name: "Fluffernutter", ingredientCount: 2, isSpicy: false),
    Sandwich(name: "Avocado toast", ingredientCount: 3, isSpicy: true),
    Sandwich(name: "Gua bao", ingredientCount: 3, isSpicy: true),
]
```

## SandwichDetail.swift
显示的详情页
```swift
import SwiftUI

struct SandwichDetail: View {
	// 接收详情信息
    var sandwich: Sandwich
    // 定义一个私有的图片状态
    @State private var zoomed = false

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            Image(sandwich.imageName)
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            Spacer(minLength: 0)
            
            // 当辣且图片没有放大时显示
            if sandwich.isSpicy && !zoomed {
                HStack{
                    Spacer()
                    Image(systemName: "flame.fill")
                    Text("Spicy")
                    Spacer()
                }
                .padding(.all)
                .font(Font.headline.smallCaps())
                .background(Color.red)
                .foregroundColor(.yellow)
                .transition(.move(edge: .bottom))
            }
        }
        .navigationTitle(sandwich.name)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SandwichDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SandwichDetail(sandwich: testData[0])
            }
            NavigationView {
                SandwichDetail(sandwich: testData[1])
            }
        }
    }
}
```
[源码下载](https://github.com/wjnhub/Sandwiches)