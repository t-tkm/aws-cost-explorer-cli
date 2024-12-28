#!/bin/bash

# START と END が未設定の場合は、今月をデフォルト値として設定
if [[ -z "${START}" ]]; then
  START=$(date +%Y-%m-01)
fi
if [[ -z "${END}" ]]; then
  END=$(date +%Y-%m-%d)
fi

# AWS認証情報の確認
if [[ -z "${AWS_ACCESS_KEY_ID}" || -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
    echo "エラー: AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY が設定されていません。"
    exit 1
fi

# セッション認証情報の確認 (任意)
if [[ -n "${AWS_SESSION_TOKEN}" ]]; then
    echo "一時的なセッション認証情報を使用しています。"
fi

# フィルタ条件を定義
FILTER='{
    "Not": {
        "Dimensions": {
            "Key": "RECORD_TYPE",
            "Values": ["Credit"]
        }
    }
}'

# AWS アカウントIDを取得
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

if [[ -z "${AWS_ACCOUNT_ID}" ]]; then
    echo "エラー: AWS アカウントIDを取得できませんでした。AWS認証情報を確認してください。"
    exit 1
fi

# AWS CLI コマンドを実行
RESULT=$(aws ce get-cost-and-usage \
    --time-period Start=${START},End=${END} \
    --granularity MONTHLY \
    --metrics "AmortizedCost" \
    --filter "${FILTER}" \
    --query "ResultsByTime[].Total[].AmortizedCost.Amount" \
    --output text)

# 結果をフォーマットして表示
if [[ -z "$RESULT" ]]; then
    echo "指定された期間 (${START} ～ ${END}) のコストデータは取得できませんでした。"
else
    echo "AWS アカウントID: ${AWS_ACCOUNT_ID}"
    echo "指定された期間 (${START} ～ ${END}) の利用料金: ${RESULT} USD"
fi