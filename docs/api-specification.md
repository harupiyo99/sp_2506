# API仕様書

## 🌐 基本情報

- **ベースURL**: `http://localhost:3000`
- **プロトコル**: HTTP/HTTPS
- **データ形式**: JSON, Binary
- **認証**: なし（開発版）

## 📚 API ドキュメント

### Swagger UI
- **URL**: `http://localhost:3000/api-docs/`
- **説明**: インタラクティブなAPIドキュメント
- **機能**: リクエスト/レスポンスのテスト、スキーマ確認

### OpenAPI仕様書
- **URL**: `http://localhost:3000/api-docs.json`
- **形式**: JSON
- **用途**: 自動生成、クライアントSDK生成

## 🔗 エンドポイント一覧

### 1. ヘルスチェック

#### GET /
サーバーの基本情報を取得

**リクエスト**
```http
GET / HTTP/1.1
Host: localhost:3000
```

**レスポンス**
```json
{
  "message": "OPRF Server is running! 🚀",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "version": "1.0.0"
}
```

**ステータスコード**
- `200 OK`: 正常

---

#### GET /api/status
サーバーの詳細なステータス情報を取得

**リクエスト**
```http
GET /api/status HTTP/1.1
Host: localhost:3000
```

**レスポンス**
```json
{
  "status": "OK",
  "runtime": "Bun",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "oprf": {
    "initialized": true
  }
}
```

**ステータスコード**
- `200 OK`: 正常
- `500 Internal Server Error`: サーバーエラー

---

### 2. OPRF処理

#### POST /upload-binary
バイナリデータをOPRFプロトコルで処理

**リクエスト**
```http
POST /upload-binary HTTP/1.1
Host: localhost:3000
Content-Type: application/octet-stream
Content-Length: <バイナリデータサイズ>

<バイナリデータ>
```

**レスポンス**
```http
HTTP/1.1 200 OK
Content-Type: application/octet-stream
Content-Length: <処理済みバイナリデータサイズ>

<処理済みバイナリデータ>
```

**ステータスコード**
- `200 OK`: 処理成功
- `400 Bad Request`: リクエストエラー
- `500 Internal Server Error`: サーバーエラー

**エラー例**
```json
{
  "error": "Invalid binary data format",
  "code": "INVALID_INPUT",
  "path": "/upload-binary",
  "method": "POST"
}
```

---

## 🔧 エラーハンドリング

### エラーレスポンス形式

すべてのエンドポイントは統一されたエラーレスポンス形式を返します：

```json
{
  "error": "エラーメッセージ",
  "code": "ERROR_CODE",
  "path": "/api/endpoint",
  "method": "GET",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### エラーコード一覧

| コード | 説明 | HTTPステータス |
|--------|------|----------------|
| `INVALID_INPUT` | 入力データが無効 | 400 |
| `OPRF_NOT_INITIALIZED` | OPRFサービスが初期化されていない | 500 |
| `PROCESSING_ERROR` | データ処理中にエラーが発生 | 500 |
| `INTERNAL_ERROR` | 内部サーバーエラー | 500 |

---

## 🔒 セキュリティ

### CORS設定
```javascript
{
  "origin": "*",
  "methods": ["GET", "POST", "OPTIONS"],
  "allowedHeaders": ["Content-Type", "Authorization"]
}
```

### リクエスト制限
- **最大リクエストサイズ**: 10MB
- **タイムアウト**: 30秒
- **レート制限**: 100リクエスト/分（予定）

---

## 📝 使用例

### JavaScript (Fetch API)

```javascript
// ヘルスチェック
const response = await fetch('http://localhost:3000/api/status');
const data = await response.json();
console.log(data);

// バイナリデータの処理
const binaryData = new Uint8Array([1, 2, 3, 4, 5]);
const response = await fetch('http://localhost:3000/upload-binary', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/octet-stream'
  },
  body: binaryData
});

const processedData = await response.arrayBuffer();
console.log(new Uint8Array(processedData));
```

### cURL

```bash
# ヘルスチェック
curl -X GET http://localhost:3000/api/status

# バイナリデータの処理
curl -X POST \
  -H "Content-Type: application/octet-stream" \
  --data-binary @input.bin \
  http://localhost:3000/upload-binary \
  --output result.bin
```

### Python

```python
import requests

# ヘルスチェック
response = requests.get('http://localhost:3000/api/status')
print(response.json())

# バイナリデータの処理
with open('input.bin', 'rb') as f:
    binary_data = f.read()

response = requests.post(
    'http://localhost:3000/upload-binary',
    data=binary_data,
    headers={'Content-Type': 'application/octet-stream'}
)

with open('result.bin', 'wb') as f:
    f.write(response.content)
```

---

## 🚀 パフォーマンス

### ベンチマーク結果

| データサイズ | 処理時間 | スループット |
|-------------|----------|-------------|
| 1KB | 5ms | 200KB/s |
| 10KB | 15ms | 667KB/s |
| 100KB | 120ms | 833KB/s |
| 1MB | 1.2s | 833KB/s |

### 最適化のヒント

1. **バッチ処理**: 複数のデータを一度に処理
2. **圧縮**: 大きなデータは事前に圧縮
3. **キャッシュ**: 同じデータの再処理を避ける
4. **並列処理**: 複数のリクエストを並列実行

---

## 🔄 バージョニング

### APIバージョン管理

現在のAPIはv1として提供されています。将来のバージョンアップ時は以下の形式で管理されます：

- **URL**: `/api/v1/`, `/api/v2/`
- **ヘッダー**: `API-Version: 1.0`
- **後方互換性**: 最低6ヶ月間維持

### 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0.0 | 2024-01-01 | 初回リリース |

---

## 📞 サポート

### 問題報告
- **GitHub Issues**: バグ報告、機能要望
- **Email**: support@example.com
- **ドキュメント**: このドキュメントを参照

### よくある質問

**Q: 最大データサイズは？**
A: 現在は10MBまで対応しています。

**Q: 同時接続数は？**
A: デフォルトでは100接続まで対応しています。

**Q: エラーが発生した場合は？**
A: エラーレスポンスの`code`フィールドを確認し、ログを確認してください。
