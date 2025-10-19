# コントリビューションガイド

## 🤝 貢献方法

このプロジェクトへの貢献を歓迎します！以下のガイドラインに従って、効果的で建設的な貢献を行ってください。

## 📋 貢献の種類

### 🐛 バグレポート
- 再現可能な手順を提供
- 期待される動作と実際の動作を明記
- 環境情報（OS、ブラウザ、バージョン）を含める

### ✨ 新機能の提案
- 機能の目的と利点を説明
- 実装の詳細を検討
- 既存の機能との整合性を確認

### 📚 ドキュメントの改善
- 不明瞭な部分の明確化
- 新しい例やチュートリアルの追加
- 翻訳の提供

### 🧪 テストの追加・改善
- テストカバレッジの向上
- エッジケースのテスト追加
- パフォーマンステストの実装

## 🚀 開発環境のセットアップ

### 1. リポジトリのフォーク
```bash
# GitHubでリポジトリをフォーク
# ローカルにクローン
git clone https://github.com/your-username/sp_2506.git
cd sp_2506
```

### 2. 依存関係のインストール
```bash
# バックエンド
cd jph-back-core
bun install

# フロントエンド
cd ../jph-front-core
bun install
```

### 3. 開発ブランチの作成
```bash
git checkout -b feature/your-feature-name
# または
git checkout -b fix/your-bug-fix
```

## 📝 コーディング規約

### TypeScript/JavaScript

#### 命名規則
```typescript
// 変数・関数: camelCase
const userName = 'john_doe';
const calculateTotal = () => {};

// クラス: PascalCase
class OPRFService {}

// 定数: UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;

// インターフェース: PascalCase with 'I' prefix
interface IUserData {}
```

#### 関数の書き方
```typescript
// 良い例
export const processUserData = async (
  userId: string,
  options: ProcessOptions
): Promise<ProcessResult> => {
  // 実装
};

// 悪い例
export function processUserData(userId, options) {
  // 実装
}
```

#### エラーハンドリング
```typescript
// 良い例
try {
  const result = await oprfService.processData(input);
  return result;
} catch (error) {
  logger.error('Failed to process data', error);
  throw new ProcessingError('Data processing failed', { cause: error });
}

// 悪い例
const result = await oprfService.processData(input);
return result;
```

### React コンポーネント

#### コンポーネントの構造
```typescript
// 良い例
interface UserProfileProps {
  userId: string;
  onUpdate?: (user: User) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({
  userId,
  onUpdate
}) => {
  const [user, setUser] = useState<User | null>(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  
  return (
    <div className="user-profile">
      {/* コンポーネントの内容 */}
    </div>
  );
};
```

#### フックの使用
```typescript
// カスタムフック
export const useUserData = (userId: string) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);
  
  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true);
        const userData = await api.getUser(userId);
        setUser(userData);
      } catch (err) {
        setError(err as Error);
      } finally {
        setLoading(false);
      }
    };
    
    fetchUser();
  }, [userId]);
  
  return { user, loading, error };
};
```

## 🧪 テストの書き方

### 単体テスト

#### バックエンドテスト
```typescript
// tests/services/OPRFService.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'bun:test';
import { OPRFService } from '../../src/services/OPRFService';

describe('OPRFService', () => {
  let oprfService: OPRFService;
  
  beforeEach(() => {
    oprfService = new OPRFService('./secrets/test-key.priv');
  });
  
  afterEach(() => {
    // クリーンアップ
  });
  
  describe('processData', () => {
    it('should process valid input data', async () => {
      // Arrange
      const input = new TextEncoder().encode('test data');
      
      // Act
      const result = await oprfService.processData(input);
      
      // Assert
      expect(result).toBeDefined();
      expect(result.length).toBeGreaterThan(0);
    });
    
    it('should throw error for invalid input', async () => {
      // Arrange
      const invalidInput = null as any;
      
      // Act & Assert
      await expect(oprfService.processData(invalidInput))
        .rejects
        .toThrow('Invalid input data');
    });
  });
});
```

#### フロントエンドテスト
```typescript
// src/components/__tests__/UserProfile.test.tsx
import { describe, it, expect, vi } from 'bun:test';
import { render, screen, waitFor } from '@testing-library/react';
import { UserProfile } from '../UserProfile';

// モック
vi.mock('../../hooks/useUserData', () => ({
  useUserData: vi.fn()
}));

describe('UserProfile', () => {
  it('renders user information correctly', async () => {
    // Arrange
    const mockUser = { id: '1', name: 'John Doe', email: 'john@example.com' };
    const { useUserData } = await import('../../hooks/useUserData');
    vi.mocked(useUserData).mockReturnValue({
      user: mockUser,
      loading: false,
      error: null
    });
    
    // Act
    render(<UserProfile userId="1" />);
    
    // Assert
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
      expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });
  });
});
```

### 統合テスト

```typescript
// tests/integration/api.test.ts
import { describe, it, expect, beforeAll, afterAll } from 'bun:test';
import request from 'supertest';
import { app } from '../../src/app';

describe('API Integration Tests', () => {
  beforeAll(async () => {
    // テストサーバーの起動
  });
  
  afterAll(async () => {
    // テストサーバーの停止
  });
  
  describe('POST /upload-binary', () => {
    it('should process binary data successfully', async () => {
      const testData = Buffer.from('test binary data');
      
      const response = await request(app)
        .post('/upload-binary')
        .send(testData)
        .expect(200);
      
      expect(response.body).toBeDefined();
    });
  });
});
```

## 📋 プルリクエストの作成

### 1. ブランチの準備
```bash
# 最新のmainブランチを取得
git checkout main
git pull origin main

# 新しいブランチを作成
git checkout -b feature/your-feature-name
```

### 2. 変更の実装
```bash
# 変更をコミット
git add .
git commit -m "feat: add new OPRF endpoint"

# ブランチをプッシュ
git push origin feature/your-feature-name
```

### 3. プルリクエストの作成

#### プルリクエストテンプレート
```markdown
## 変更内容
- 変更の概要を記述

## 変更の種類
- [ ] バグ修正
- [ ] 新機能
- [ ] 破壊的変更
- [ ] ドキュメント更新

## テスト
- [ ] 単体テストを追加/更新
- [ ] 統合テストを追加/更新
- [ ] 手動テストを実行

## チェックリスト
- [ ] コードがプロジェクトのコーディング規約に従っている
- [ ] 自己レビューを実行した
- [ ] コメントを追加した（特に理解しにくい部分）
- [ ] 対応するドキュメントを更新した
- [ ] 変更が既存の機能を壊していない
```

## 🔍 コードレビューのガイドライン

### レビュアー向けチェックリスト

#### 機能性
- [ ] コードが要件を満たしている
- [ ] エッジケースが適切に処理されている
- [ ] エラーハンドリングが適切

#### コード品質
- [ ] コードが読みやすい
- [ ] 適切な命名がされている
- [ ] 重複コードがない
- [ ] 適切な抽象化レベル

#### パフォーマンス
- [ ] パフォーマンスに問題がない
- [ ] メモリリークがない
- [ ] 適切なキャッシュ戦略

#### セキュリティ
- [ ] セキュリティホールがない
- [ ] 入力検証が適切
- [ ] 機密情報の漏洩がない

### コメントの書き方

#### 良いコメント
```typescript
/**
 * OPRFプロトコルを使用してデータを処理します
 * 
 * @param input - 処理するバイナリデータ
 * @param options - 処理オプション
 * @returns 処理済みのバイナリデータ
 * @throws {InvalidInputError} 入力データが無効な場合
 * @throws {OPRFError} OPRF処理中にエラーが発生した場合
 */
export const processData = async (
  input: Uint8Array,
  options: ProcessOptions
): Promise<Uint8Array> => {
  // 入力データの検証
  if (!input || input.length === 0) {
    throw new InvalidInputError('Input data cannot be empty');
  }
  
  // OPRF処理の実行
  // 注意: この処理は暗号学的に安全でなければならない
  const result = await oprfService.process(input);
  
  return result;
};
```

#### 悪いコメント
```typescript
// データを処理する
export const processData = (input) => {
  // 処理
  return result;
};
```

## 🚀 リリースプロセス

### バージョニング
- **メジャー**: 破壊的変更
- **マイナー**: 新機能追加
- **パッチ**: バグ修正

### リリース手順
1. バージョン番号の更新
2. CHANGELOGの更新
3. タグの作成
4. リリースノートの作成

## 📞 サポート・質問

### 質問の方法
- **GitHub Issues**: バグ報告、機能要望
- **GitHub Discussions**: 一般的な質問、議論
- **Pull Request**: コードレビュー中の質問

### 質問の書き方
```markdown
## 環境
- OS: macOS 13.0
- Bun: 1.0.0
- Node.js: 18.17.0

## 問題の説明
具体的に何が起こっているかを説明

## 期待される動作
何が起こるべきかを説明

## 実際の動作
何が起こっているかを説明

## 再現手順
1. 手順1
2. 手順2
3. 手順3

## 追加情報
ログ、スクリーンショット、関連するIssueなど
```

## 🎉 貢献者の認証

貢献者として認められる条件：
- 有効なプルリクエストのマージ
- ドキュメントの改善
- バグレポートの提供
- コミュニティでの支援

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。貢献するコードも同じライセンスの下で公開されることに同意してください。

---

**ありがとうございます！** このプロジェクトへの貢献を心より歓迎します。質問や提案があれば、お気軽にお声がけください。
