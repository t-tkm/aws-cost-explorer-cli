# aws-cost-explorer-cli
このスクリプトは、AWS CLI を使用して AWS Cost Explorer から指定した期間の利用料金を取得します。
期間指定やクレジット除外フィルタをサポートし、簡単にコストを追跡可能です。

## 特徴
- 指定した期間の "AmortizedCost" を取得します。
- デフォルトでクレジット（`RECORD_TYPE = Credit`）を除外します。
- 期間が指定されていない場合は、現在の月をデフォルトとして使用します。

## 実行例
```bash
$ aws-cost-explorer-cli % ./get-aws-cost.sh 
一時的なセッション認証情報を使用しています。
AWS アカウントID: 123456789012
指定された期間 (2024-12-01 ～ 2024-12-28) の利用料金: 16.3730764302 USD
```

---

## 必要条件

1. **AWS CLI**
   - AWS CLI がインストールされ、設定されている必要があります。
   - AWS CLI のバージョン 2 を推奨します。

2. **AWS 認証情報**
   以下の環境変数を設定してください：
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - （オプション）`AWS_SESSION_TOKEN`（一時的なセッション認証を使用する場合）

3. **Bash**
   - このスクリプトは Unix 系のシェル環境で動作します。
   - スクリプトに実行権限を付与します(初回)。
      ```
      chmod +x get-aws-cost.sh
      ```

---

## 参考情報

### AWS 認証情報の取得方法
AWS で一時的な認証情報を取得する方法についての詳細は、以下の公式ドキュメントをご参照ください：
- [AWS リソースを使用するための一時的な認証情報](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_credentials_temp_use-resources.html)

このドキュメントでは、一時的なセキュリティ認証情報を使用して AWS リソースにアクセスする方法と、それを設定および管理する方法について詳しく説明しています。

### AWS SSO による CLI アクセスの活用
AWS SSO を使用して、CLI 経由で AWS アカウントにアクセスする方法については、以下の AWS ブログ記事を参考にしてください：
- [AWS Single Sign-On が CLI アクセスをサポート](https://aws.amazon.com/jp/blogs/news/aws-single-sign-on-now-enables-command-line-interface-access-for-aws-accounts-using-corporate-credentials/)

この記事では、AWS SSO を使用して企業の認証情報で CLI にアクセスする設定手順と利便性について説明しています。

---

## 使用方法

### 環境変数の設定

スクリプトを実行する前に、以下の環境変数を設定してください：

- **必須**
  ```bash
  export AWS_ACCESS_KEY_ID="your_access_key_id"
  export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
  ```

- **オプション**
  - 一時的なセッション認証を使用する場合：
    ```bash
    export AWS_SESSION_TOKEN="your_session_token"
    ```

- **カスタム期間の指定**
  - デフォルトでは、現在の月の開始日（`YYYY-MM-01`）から本日までのデータを取得します。
  - カスタム期間を指定する場合：
    ```bash
    export START="YYYY-MM-DD"
    export END="YYYY-MM-DD"
    ```

---

### スクリプトの実行

以下のコマンドでスクリプトを実行します：

```bash
./cost_retrieval.sh
```

### 出力
- 成功時には以下の情報が表示されます：
  ```
  AWS アカウントID: <account_id>
  指定された期間 (<start_date> ～ <end_date>) の利用料金: <amount> USD
  ```

- エラーが発生した場合、対応するエラーメッセージが表示されます。

---

## エラー処理

1. **AWS 認証情報が未設定の場合**
   ```
   エラー: AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY が設定されていません。
   ```

2. **AWS アカウントIDを取得できない場合**
   ```
   エラー: AWS アカウントIDを取得できませんでした。AWS 認証情報を確認してください。
   ```

3. **指定した期間のデータが取得できない場合**
   ```
   指定された期間 (<start_date> ～ <end_date>) のコストデータは取得できませんでした。
   ```

---

## 注意事項
- このスクリプトは `AWS Cost Explorer` を使用してデータを取得します。そのため、AWS アカウントで Cost Explorer が有効化されている必要があります。
- 利用料金は USD 単位で表示されます。

---

## ライセンス
このスクリプトは MIT ライセンスの下で提供されます。詳細は [LICENSE](LICENSE) ファイルをご参照ください。