# 開発ガイド

## 🛠️ 開発環境の構築

### 前提条件
- Bun 1.0以上
- Git 2.0以上
- エディタ（VS Code推奨）

### 推奨VS Code拡張機能
```json
{
  "recommendations": [
    "bun.vscode-bun",
    "ms-vscode.vscode-typescript-next",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss"
  ]
}
```

## 📁 プロジェクト構造

```
sp_2506/
├── jph-back-core/                 # バックエンド
│   ├── src/
│   │   ├── config/               # 設定ファイル
│   │   │   └── swagger.ts         # Swagger設定
│   │   └── services/              # サービス層
│   │       ├── ExpressService.ts   # Expressサーバー
│   │       └── OPRFService.ts     # OPRF処理
│   ├── tests/                     # テストファイル
│   ├── examples/                  # 使用例
│   ├── docs/                      # バックエンド専用ドキュメント
│   └── secrets/                   # 秘密鍵ファイル
├── jph-front-core/               # フロントエンド
│   ├── src/
│   │   ├── components/            # Reactコンポーネント
│   │   ├── hooks/                 # カスタムフック
│   │   ├── lib/                   # ユーティリティ
│   │   └── assets/                # 静的ファイル
│   └── public/                    # 公開ファイル
└── docs/                          # プロジェクト全体のドキュメント
```

## 🔧 開発ワークフロー

### 1. ブランチ戦略

```bash
# 機能開発用ブランチ
git checkout -b feature/your-feature-name

# バグ修正用ブランチ
git checkout -b fix/your-bug-fix

# ホットフィックス用ブランチ
git checkout -b hotfix/critical-issue
```

### 2. コミット規約

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

#### タイプ一覧
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント更新
- `style`: コードスタイル修正
- `refactor`: リファクタリング
- `test`: テスト追加・修正
- `chore`: その他の変更

#### 例
```bash
git commit -m "feat(api): add new OPRF endpoint"
git commit -m "fix(ui): resolve button alignment issue"
git commit -m "docs: update API documentation"
```

### 3. プルリクエスト作成

```bash
# ブランチをプッシュ
git push origin feature/your-feature-name

# GitHubでプルリクエストを作成
# テンプレートを使用して詳細を記入
```

## 🧪 テスト戦略

### バックエンドテスト

#### テスト構造
```
jph-back-core/tests/
├── unit/                    # 単体テスト
│   ├── services/           # サービス層テスト
│   └── utils/              # ユーティリティテスト
├── integration/            # 統合テスト
│   └── api/                # APIテスト
├── e2e/                    # エンドツーエンドテスト
└── fixtures/               # テストデータ
```

#### テスト実行
```bash
# 全テスト実行
bun test

# 特定のテストファイル
bun test tests/oprf.test.ts

# カバレッジ付きテスト
bun test --coverage

# ウォッチモード
bun test --watch
```

#### テスト例
```typescript
// tests/services/OPRFService.test.ts
import { describe, it, expect, beforeEach } from 'bun:test';
import { OPRFService } from '../../src/services/OPRFService';

describe('OPRFService', () => {
  let oprfService: OPRFService;

  beforeEach(async () => {
    oprfService = new OPRFService('./secrets/key.priv');
    await oprfService.initialize();
  });

  it('should process data correctly', async () => {
    const input = new TextEncoder().encode('test data');
    const result = await oprfService.processData(input);
    
    expect(result).toBeDefined();
    expect(result.length).toBeGreaterThan(0);
  });
});
```

### フロントエンドテスト

#### テスト構造
```
jph-front-core/src/
├── components/
│   ├── __tests__/          # コンポーネントテスト
│   └── Component.tsx
├── hooks/
│   ├── __tests__/          # フックテスト
│   └── useHook.ts
└── lib/
    ├── __tests__/          # ユーティリティテスト
    └── utils.ts
```

#### テスト実行
```bash
# 全テスト実行
bun test

# コンポーネントテスト
bun test src/components/__tests__/

# カバレッジ付きテスト
bun test --coverage
```

#### テスト例
```typescript
// src/components/__tests__/InputForm.test.tsx
import { describe, it, expect } from 'bun:test';
import { render, screen } from '@testing-library/react';
import { InputForm } from '../InputForm';

describe('InputForm', () => {
  it('renders input field correctly', () => {
    render(<InputForm onSubmit={() => {}} />);
    
    const input = screen.getByRole('textbox');
    expect(input).toBeInTheDocument();
  });
});
```

## 🔍 コード品質管理

### ESLint設定

#### バックエンド用ESLint
```json
// jph-back-core/.eslintrc.json
{
  "extends": [
    "@typescript-eslint/recommended",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn"
  }
}
```

#### フロントエンド用ESLint
```json
// jph-front-core/.eslintrc.json
{
  "extends": [
    "react-app",
    "react-app/jest",
    "prettier"
  ],
  "rules": {
    "react-hooks/exhaustive-deps": "warn",
    "no-console": "warn"
  }
}
```

### Prettier設定

```json
// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

### コード品質チェック

```bash
# ESLint実行
bun run lint

# Prettier実行
bun run format

# 型チェック
bun run type-check

# 全品質チェック
bun run quality-check
```

## 🚀 開発サーバー

### バックエンド開発サーバー

```bash
cd jph-back-core

# 開発モード
bun run dev

# デバッグモード
DEBUG=* bun run dev

# 本番モード
bun run start
```

#### 環境変数
```bash
# .env.development
NODE_ENV=development
PORT=3000
DEBUG=true
OPRF_PRIVATE_KEY_PATH=./secrets/key.priv
```

### フロントエンド開発サーバー

```bash
cd jph-front-core

# 開発モード
bun run dev

# プレビューモード
bun run preview

# ビルド
bun run build
```

#### 環境変数
```bash
# .env.local
VITE_API_BASE_URL=http://localhost:3000
VITE_DEBUG=true
VITE_APP_NAME=OPRF Client
```

## 🔧 デバッグ

### バックエンドデバッグ

#### ログ設定
```typescript
// src/config/logger.ts
import { createLogger, format, transports } from 'winston';

export const logger = createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: format.combine(
    format.timestamp(),
    format.errors({ stack: true }),
    format.json()
  ),
  transports: [
    new transports.Console(),
    new transports.File({ filename: 'logs/error.log', level: 'error' }),
    new transports.File({ filename: 'logs/combined.log' })
  ]
});
```

#### デバッグツール
```bash
# Node.jsデバッガー
bun --inspect run dev

# Chrome DevToolsで接続
# chrome://inspect
```

### フロントエンドデバッグ

#### React Developer Tools
```bash
# Chrome拡張機能をインストール
# React Developer Tools
# Redux DevTools
```

#### デバッグ用コンポーネント
```typescript
// src/components/DebugPanel.tsx
import { useState, useEffect } from 'react';

export const DebugPanel = () => {
  const [debugInfo, setDebugInfo] = useState({});

  useEffect(() => {
    // デバッグ情報を収集
    setDebugInfo({
      userAgent: navigator.userAgent,
      timestamp: new Date().toISOString(),
      apiUrl: import.meta.env.VITE_API_BASE_URL
    });
  }, []);

  if (import.meta.env.DEV) {
    return (
      <div className="debug-panel">
        <pre>{JSON.stringify(debugInfo, null, 2)}</pre>
      </div>
    );
  }

  return null;
};
```

## 📦 パッケージ管理

### 依存関係の管理

#### 新規パッケージの追加
```bash
# 本番依存関係
bun add package-name

# 開発依存関係
bun add -d package-name

# グローバルパッケージ
bun add -g package-name
```

#### パッケージの更新
```bash
# 全パッケージ更新
bun update

# 特定パッケージ更新
bun update package-name

# 古いパッケージ確認
bun outdated
```

### セキュリティ監査

```bash
# 脆弱性チェック
bun audit

# 自動修正
bun audit --fix
```

## 🔄 CI/CD

### GitHub Actions設定

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: oven-sh/setup-bun@v1
      
      - name: Install dependencies
        run: bun install
        
      - name: Run tests
        run: bun test
        
      - name: Run linting
        run: bun run lint
        
      - name: Build
        run: bun run build
```

## 📊 パフォーマンス監視

### バックエンド監視

```typescript
// src/middleware/performance.ts
import { Request, Response, NextFunction } from 'express';

export const performanceMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} - ${duration}ms`);
  });
  
  next();
};
```

### フロントエンド監視

```typescript
// src/lib/performance.ts
export const measurePerformance = (name: string, fn: () => void) => {
  const start = performance.now();
  fn();
  const end = performance.now();
  
  console.log(`${name}: ${end - start}ms`);
};
```

## 🚀 デプロイメント

### 本番環境へのデプロイ

#### バックエンドデプロイ
```bash
# 本番ビルド
bun run build

# 本番サーバー起動
NODE_ENV=production bun run start
```

#### フロントエンドデプロイ
```bash
# 本番ビルド
bun run build

# 静的ファイルをサーバーにデプロイ
rsync -av dist/ user@server:/var/www/html/
```

## 📚 参考資料

### 公式ドキュメント
- [Bun公式ドキュメント](https://bun.sh/docs)
- [Express.js公式ドキュメント](https://expressjs.com/)
- [React公式ドキュメント](https://react.dev/)

### ベストプラクティス
- [TypeScript Best Practices](https://typescript-eslint.io/rules/)
- [React Best Practices](https://react.dev/learn)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)

### ツール
- [VS Code拡張機能](https://code.visualstudio.com/docs/editor/extension-marketplace)
- [Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools)
- [Postman](https://www.postman.com/) - APIテスト
