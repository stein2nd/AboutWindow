# 0. 概要
AboutWindowは、Danger CoveさんのObjective-C製フレームワーク「[DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)」をSwiftで書き直したものです。
現在、cocoapods未対応です。

AboutWindowは、標準のAboutダイアログに代わるものです。
クリックすることで、謝辞を開いたり、ウェブサイトを訪問したりするオプションボタンが追加されます。

![動作中のAboutWindow](https://raw.github.com/DangerCove/DCOAboutWindow/master/screenshots/DCOAboutWindow.png)
![ダークモードのAboutWindow](https://raw.github.com/DangerCove/DCOAboutWindow/master/screenshots/DCOAboutWindow-DarkMode.png)

## 0.1. 謝辞の表示
独自の`Acknowledgments.rtf`ファイルを指定して管理できるし、或いは[Acknowledge](https://github.com/DangerCove/Acknowledge)の様なスクリプトを使用して生成することもできます。

# 1. セットアップ
## 1.1. [Swift Package Manager](https://swift.org/package-manager/)経由
Swift Package Managerは、Swiftライブラリ/フレームワークの配布を自動化する為のツールで、Swiftコンパイラーに統合されています。Swiftパッケージを設定したら、`Package.swift`の「dependencies」値に追加するだけで簡単にAboutWindowを`dependency`として追加できます。

## 1.2. [carthage](https://github.com/Carthage/Carthage)経由
Cartfileに追加してください：
```bash
github "stein2nd/AboutWindow"
github "stein2nd/TransparentScroller"
```
それから`carthage update`を実行すれば、準備完了です。

## 1.3. 手動
このリポジトリをクローンして、`AboutWindow`のファイルをプロジェクトに追加します。
このプロジェクトは[TransparentScroller](https://github.com/stein2nd/TransparentScroller)に依存しているので、そちらも含めてください。

# 2. 使用法
この小さなガイドに付随する[サンプルプロジェクト](https://github.com/DangerCove/DCOAboutWindowExample)を作ってみました。

`AboutWindow`をインポートします：
```swift
import AboutWindow
```

`AboutWindowController`のインスタンスを作成します：
```swift
/// aboutウィンドウを処理するウィンドウコントローラー。
private var _aboutWindowController: AboutWindowController?

/// aboutウィンドウを処理するウィンドウコントローラー。
private var aboutWindowController: AboutWindowController? {
	if self._aboutWindowController == nil {
		self._aboutWindowController = AboutWindowController.init()
	}
	return self._aboutWindowController
}
```

ウィンドウを表示する為のIBActionメソッドを作成します：
```swift
@IBAction func showAboutWindow(_ sender: Any) {
	// aboutウィンドウを表示する
	self.aboutWindowController?.showWindow(nil)
}
```

メニュー項目「About アプリ名」やボタンに接続してください。

`AboutWindowController`のプロパティを設定することで、値を変更できます：
```swift
/// アプリケーションの名称。
/// デフォルト値：CFBundleName
var appName: String?

/// アプリケーションのバージョン。
/// デフォルト値："Version %1@ (Build %2@)", CFBundleVersion, CFBundleShortVersionString
var appVersion: String?

/// 著作権の行。
/// デフォルト値：NSHumanReadableCopyright
var appCopyright: String?

/// クレジット。
/// デフォルト値：Bundle.main.path(forResource: "Credits", ofType: "rtf")にあるファイルの内容
var appCredits: NSAttributedString?

/// アプリケーションのWebサイトを指すURL。
/// デフォルト値：nil
var appWebsiteURL: URL?

/// 謝辞を含むファイルへのパス。
/// デフォルト値：Bundle.main.path(forResource: "Acknowledgments", ofType: "rtf")
var acknowledgmentsPath: String?

/// trueに設定されている場合、謝辞はウィンドウ内のテキストビューに表示されます。それ以外の場合は、外部エディタが起動します。
/// デフォルト値：false
var useTextViewForAcknowledgments = false
```

## 2.1. 前処理（ダークモード用）
デリゲートを使用して、アプリのクレジットを含む`NSAttributedString`を前処理できます。これは、Mojaveのダークモードでaboutウィンドウをうまく表示させるのに最適です。以下にその仕組みを示します：
```swift
@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate, StringPreprocessingProtocol {

	/// aboutウィンドウを処理するウィンドウコントローラー。
	private var _aboutWindowController: AboutWindowController?

	/// aboutウィンドウを処理するウィンドウコントローラー。
	private var aboutWindowController: AboutWindowController? {
		if self._aboutWindowController == nil {
			self._aboutWindowController = AboutWindowController.init()

			// デリゲートを設定する
			self._aboutWindowController?.delegate = self
		}
		return self._aboutWindowController
	}


	//MARK: - StringPreprocessingProtocol

	/// Given the credits loaded from the bundle, expects a modified version to be used in return.
	/// - Parameter appCredits: <#appCredits description#>
	/// - Returns: <#description#>
	func preprocessAppCredits(_ appCredits: NSAttributedString?) -> NSAttributedString? {
		let credits: NSMutableAttributedString? = appCredits as? NSMutableAttributedString

		let attributes: [ NSAttributedString.Key : NSColor ] = [ NSAttributedString.Key.foregroundColor: NSColor.textColor ]
		let range: NSRange = NSRange.init(location: 0, length: credits?.length ?? 0)

		credits?.addAttributes(attributes, range: range)

		return credits
	}

	/// Given the acknowledgments loaded from the bundle, expects a modified version to be used in return.
	/// - Parameter appAcknowledgments: <#appAcknowledgments description#>
	/// - Returns: <#description#>
	func preprocessAppAcknowledgments(_ appAcknowledgments: NSAttributedString?) -> NSAttributedString? {
		let acknowledgments: NSMutableAttributedString? = appAcknowledgments as? NSMutableAttributedString

		let attributes: [ NSAttributedString.Key : NSColor ] = [ NSAttributedString.Key.foregroundColor: NSColor.textColor ]
		let range: NSRange = NSRange.init(location: 0, length: acknowledgments?.length ?? 0)

		acknowledgments?.addAttributes(attributes, range: range)

		return acknowledgments
	}
}
```

追加してくれた[@balthisar](https://github.com/balthisar)さんに感謝します。

# 3. ローカライゼーション
Localizable.stringsに次の行を追加して、これらの値を変更したり、ローカライズしたりします。

```strings
// InfoViewのラベル「appVersion」に表示される文字列。
"label_appVersion" = "v%1@ (%2@)";

// Window上のボタン「visitWebsiteButton」に表示される文字列。
"buttonLabel_VisitWebsite" = "Visit the %1@ Website";

// Window上のボタン「Acknowledgments」に表示する文字列。
"buttonLabel_Acknowledgments" = "Acknowledgments";

// 変数値「useTextViewForAcknowledgments」がtrueの場合、Window上のボタン「Acknowledgments」に表示される代替文字列。
"buttonLabel_Credits" = "Credits";
```

# 4. 貢献、そして機能の追加
創造的であること。AboutWindowは、アプリの"About Window"を美しく見せるため、柔軟で、容易な方法でなければなりません。正当な理由なく、既存の機能を損なっていないことを確認してください。
pull requestを作成するには：
* リポジトリをフォークします；
* 新しいブランチを作成します（`git checkout -b your-feature`）；
* コードを追加します；
* すべての変更をブランチにコミットします；
* ブランチをプッシュします（`git push origin your-feature`）；
* GitHubのウェブ・インターフェースを使ってpull requestを送信します。

## 4.1. スピンオフ
大規模な修正を行なった場合は、このセクションにあなたのプロジェクトを含めて、私に知らせてください。リストにあなた自身を追加して、pull requestを送ってください。

* [GitHub上のあなたのプロジェクト](http://www.dangercove.com) - 簡単な説明。

## 4.2. アドオン
AboutWindowの機能を拡張する、関連アプリ、ツール、スクリプトです。

* [Acknowledge](https://github.com/DangerCove/Acknowledge) - CocoaPodsとカスタムmarkdownファイルから単一の`Acknowledgments.rtf`を生成します。

# 5. ライセンス
New BSDライセンス、詳細は`LICENSE`ファイルを参照してください。
