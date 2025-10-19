# アーキテクチャ

## 🏗️ システム全体構成

### 高レベルアーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Layer                         │
├─────────────────────────────────────────────────────────────┤
│  React Frontend (jph-front-core)                           │
│  • UI Components                                           │
│  • State Management                                         │
│  • API Client                                              │
└─────────────────────────────────────────────────────────────┘
                                │
                                │ HTTP/HTTPS
                                │
┌─────────────────────────────────────────────────────────────┐
│                      Application Layer                      │
├─────────────────────────────────────────────────────────────┤
│  Express.js Backend (jph-back-core)                        │
│  • REST API Endpoints                                       │
│  • Request/Response Handling                               │
│  • Authentication & Authorization                          │
└─────────────────────────────────────────────────────────────┘
                                │
                                │
┌─────────────────────────────────────────────────────────────┐
│                       Service Layer                         │
├─────────────────────────────────────────────────────────────┤
│  • OPRF Service                                             │
│  • Business Logic                                           │
│  • Data Processing                                          │
└─────────────────────────────────────────────────────────────┘
                                │
                                │
┌─────────────────────────────────────────────────────────────┐
│                       Security Layer                        │
├─────────────────────────────────────────────────────────────┤
│  • Private Key Management                                   │
│  • Cryptographic Operations                                 │
│  • Secure Data Storage                                      │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 技術スタック

### フロントエンド技術

| 技術 | バージョン | 用途 |
|------|------------|------|
| React | 18.x | UI フレームワーク |
| TypeScript | 5.x | 型安全なJavaScript |
| Vite | 5.x | ビルドツール・開発サーバー |
| Bun | 1.x | パッケージマネージャー・ランタイム |

### バックエンド技術

| 技術 | バージョン | 用途 |
|------|------------|------|
| Bun | 1.x | ランタイム・パッケージマネージャー |
| Express.js | 4.x | Webフレームワーク |
| TypeScript | 5.x | 型安全なJavaScript |
| @cloudflare/voprf-ts | Latest | OPRFプロトコル実装 |

### 開発・運用ツール

| ツール | 用途 |
|--------|------|
| ESLint | コード品質管理 |
| Prettier | コードフォーマット |
| Bun Test | テストフレームワーク |
| Swagger | API ドキュメント |
| Docker | コンテナ化 |

## 🏛️ アーキテクチャパターン

### 1. レイヤードアーキテクチャ

```
┌─────────────────┐
│   Presentation  │ ← UI Layer (React Components)
├─────────────────┤
│   Application   │ ← Business Logic (Services)
├─────────────────┤
│   Domain        │ ← Core Logic (OPRF Protocol)
├─────────────────┤
│   Infrastructure│ ← External Services (File System)
└─────────────────┘
```

### 2. マイクロサービス指向

```
┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │
│   Service       │◄──►│   Service       │
│                 │    │                 │
│ • UI Components │    │ • OPRF Service  │
│ • API Client    │    │ • REST API      │
│ • State Mgmt    │    │ • Auth System   │
└─────────────────┘    └─────────────────┘
```

### 3. イベント駆動アーキテクチャ

```
┌─────────────────┐
│   User Action   │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│   Event Bus     │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│   Event Handler │
└─────────────────┘
```

## 🔐 セキュリティアーキテクチャ

### セキュリティレイヤー

```
┌─────────────────────────────────────────┐
│           Security Layers               │
├─────────────────────────────────────────┤
│ 1. Network Security (HTTPS/TLS)        │
│ 2. Application Security (CORS, CSP)    │
│ 3. Authentication & Authorization       │
│ 4. Data Encryption (OPRF Protocol)     │
│ 5. Secure Key Management               │
└─────────────────────────────────────────┘
```

### OPRFプロトコルフロー

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Client    │    │   Server      │    │   Client    │
│             │    │               │    │             │
│ 1. Input    │───►│ 2. Process    │───►│ 3. Result   │
│    Data     │    │    (OPRF)     │    │    Data     │
│             │    │               │    │             │
│ • Private   │    │ • Private     │    │ • Processed │
│   Key       │    │   Key         │    │   Data      │
│ • Public    │    │ • Public      │    │ • No Access │
│   Key       │    │   Key         │    │   to Input  │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 📊 データフロー

### 1. ユーザーリクエストフロー

```
User Input → Frontend → API Call → Backend → OPRF Service → Response
     │           │         │          │           │           │
     ▼           ▼         ▼          ▼           ▼           ▼
  Form Data → Component → HTTP → Express → Process → JSON
```

### 2. エラーハンドリングフロー

```
Error → Service Layer → Middleware → Response Formatter → Client
  │         │              │              │                │
  ▼         ▼              ▼              ▼                ▼
Exception → Log → Error Handler → JSON Error → User Message
```

## 🚀 パフォーマンス最適化

### フロントエンド最適化

```typescript
// コンポーネント最適化
const OptimizedComponent = React.memo(({ data }) => {
  const memoizedValue = useMemo(() => {
    return expensiveCalculation(data);
  }, [data]);

  return <div>{memoizedValue}</div>;
});

// 遅延読み込み
const LazyComponent = React.lazy(() => import('./LazyComponent'));
```

### バックエンド最適化

```typescript
// キャッシュ戦略
const cache = new Map();

export const cachedOPRFProcess = async (input: Uint8Array) => {
  const key = hash(input);
  
  if (cache.has(key)) {
    return cache.get(key);
  }
  
  const result = await oprfService.processData(input);
  cache.set(key, result);
  
  return result;
};
```

## 🔄 スケーラビリティ設計

### 水平スケーリング

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Load      │    │   Load      │    │   Load      │
│  Balancer   │───►│  Balancer   │───►│  Balancer   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Backend   │    │   Backend   │    │   Backend   │
│  Instance 1 │    │  Instance 2 │    │  Instance 3 │
└─────────────┘    └─────────────┘    └─────────────┘
```

### 垂直スケーリング

```
┌─────────────────────────────────────────┐
│              Single Instance            │
│                                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐ │
│  │   CPU   │  │ Memory   │  │ Storage │ │
│  │   ↑     │  │    ↑     │  │    ↑    │ │
│  │ Scaling │  │ Scaling  │  │ Scaling │ │
│  └─────────┘  └─────────┘  └─────────┘ │
└─────────────────────────────────────────┘
```

## 🐳 コンテナ化アーキテクチャ

### Docker構成

```yaml
# docker-compose.yml
version: '3.8'
services:
  frontend:
    build: ./jph-front-core
    ports:
      - "3000:80"
    environment:
      - VITE_API_BASE_URL=http://backend:3000
    depends_on:
      - backend

  backend:
    build: ./jph-back-core
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
    volumes:
      - ./secrets:/app/secrets:ro
```

### Kubernetes構成

```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: oprf-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: oprf-backend
  template:
    metadata:
      labels:
        app: oprf-backend
    spec:
      containers:
      - name: backend
        image: oprf-backend:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
```

## 📈 監視・ログ設計

### 監視メトリクス

```typescript
// メトリクス収集
export const metrics = {
  requestCount: 0,
  responseTime: [],
  errorCount: 0,
  activeConnections: 0
};

// パフォーマンス監視
export const performanceMonitor = {
  startTime: Date.now(),
  
  recordRequest() {
    metrics.requestCount++;
  },
  
  recordResponseTime(time: number) {
    metrics.responseTime.push(time);
  },
  
  recordError() {
    metrics.errorCount++;
  }
};
```

### ログ設計

```typescript
// 構造化ログ
export const logger = {
  info: (message: string, meta?: object) => {
    console.log(JSON.stringify({
      level: 'info',
      message,
      timestamp: new Date().toISOString(),
      ...meta
    }));
  },
  
  error: (message: string, error?: Error, meta?: object) => {
    console.error(JSON.stringify({
      level: 'error',
      message,
      error: error?.stack,
      timestamp: new Date().toISOString(),
      ...meta
    }));
  }
};
```

## 🔮 将来の拡張性

### マイクロサービス化

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   API       │    │   OPRF      │    │   Auth      │
│  Gateway    │───►│  Service    │    │  Service    │
│             │    │             │    │             │
│ • Routing   │    │ • OPRF      │    │ • JWT       │
│ • Rate      │    │   Protocol  │    │ • OAuth     │
│   Limiting  │    │ • Crypto    │    │ • RBAC      │
└─────────────┘    └─────────────┘    └─────────────┘
```

### イベント駆動アーキテクチャ

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Event     │    │   Event     │    │   Event      │
│  Publisher  │───►│   Bus       │───►│  Consumer    │
│             │    │             │    │              │
│ • User      │    │ • Message   │    │ • Analytics  │
│   Actions   │    │   Queue     │    │ • Logging    │
│ • System    │    │ • Event     │    │ • Notifications│
│   Events    │    │   Routing   │    │ • Processing │
└─────────────┘    └─────────────┘    └─────────────┘
```

このアーキテクチャ設計により、システムの拡張性、保守性、セキュリティを確保しながら、将来の要件変更にも柔軟に対応できる構造を実現しています。
