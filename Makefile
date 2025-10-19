# OPRF Project Makefile
# プロジェクトのビルド、テスト、デプロイメントを自動化するためのMakefile

# 変数定義
PROJECT_NAME := jphacks-oprf
BACKEND_DIR := jph-back-core
FRONTEND_DIR := jph-front-core
DOCS_DIR := docs

# バージョン情報
VERSION := 1.0.0
BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
GIT_COMMIT := $(shell git rev-parse --short HEAD)

# デフォルトターゲット
.DEFAULT_GOAL := help

# カラー出力用
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color

# ヘルプメッセージ
.PHONY: help
help: ## 利用可能なコマンドを表示
	@echo "$(CYAN)OPRF Project Makefile$(NC)"
	@echo "$(CYAN)========================$(NC)"
	@echo ""
	@echo "$(YELLOW)利用可能なコマンド:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)例:$(NC)"
	@echo "  make setup          # 開発環境をセットアップ"
	@echo "  make dev            # 開発サーバーを起動"
	@echo "  make test           # テストを実行"
	@echo "  make build          # プロジェクトをビルド"

# セットアップ関連
.PHONY: setup
setup: setup-deps setup-backend setup-frontend setup-docs ## 開発環境を完全にセットアップ
	@echo "$(GREEN)✅ セットアップが完了しました！$(NC)"
	@echo "$(CYAN)次のステップ:$(NC)"
	@echo "  make dev    # 開発サーバーを起動"
	@echo "  make test   # テストを実行"

.PHONY: setup-deps
setup-deps: install-tools ## 依存関係をインストール
	@echo "$(BLUE)📦 依存関係をインストール中...$(NC)"
	@if command -v bun >/dev/null 2>&1; then \
		echo "$(GREEN)✅ Bun がインストールされています$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Bun をインストールしてください$(NC)"; \
		echo "$(CYAN)curl -fsSL https://bun.sh/install | bash$(NC)"; \
		exit 1; \
	fi

.PHONY: setup-backend
setup-backend: ## バックエンド環境をセットアップ
	@echo "$(BLUE)🔧 バックエンド環境をセットアップ中...$(NC)"
	@cd $(BACKEND_DIR) && \
		echo "$(YELLOW)📦 バックエンド依存関係をインストール中...$(NC)" && \
		bun install && \
		echo "$(YELLOW)🔐 秘密鍵ディレクトリを作成中...$(NC)" && \
		mkdir -p secrets && \
		if [ ! -f secrets/key.priv ] || [ ! -s secrets/key.priv ]; then \
			echo "$(YELLOW)🔑 開発用秘密鍵を生成中...$(NC)" && \
			openssl rand -hex 32 > secrets/key.priv && \
			chmod 600 secrets/key.priv && \
			echo "$(GREEN)✅ 新しい秘密鍵を生成しました$(NC)"; \
		else \
			echo "$(GREEN)✅ 既存の秘密鍵を使用します$(NC)"; \
		fi && \
		echo "$(GREEN)✅ バックエンドセットアップ完了$(NC)"

.PHONY: generate-key
generate-key: ## 新しい秘密鍵を生成
	@echo "$(BLUE)🔑 新しい秘密鍵を生成中...$(NC)"
	@cd $(BACKEND_DIR) && \
		mkdir -p secrets && \
		openssl rand -hex 32 > secrets/key.priv && \
		chmod 600 secrets/key.priv && \
		echo "$(GREEN)✅ 新しい秘密鍵を生成しました$(NC)" && \
		echo "$(YELLOW)📁 秘密鍵ファイル: $(BACKEND_DIR)/secrets/key.priv$(NC)"

.PHONY: install-tools
install-tools: ## 開発ツールをインストール
	@echo "$(BLUE)🛠️  開発ツールをインストール中...$(NC)"
	@echo "$(YELLOW)📦 Bun の確認中...$(NC)"
	@if command -v bun >/dev/null 2>&1; then \
		echo "$(GREEN)✅ Bun がインストールされています$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Bun をインストールしてください$(NC)"; \
		echo "$(CYAN)curl -fsSL https://bun.sh/install | bash$(NC)"; \
		exit 1; \
	fi

	@echo "$(YELLOW)📦 VS Code 拡張機能の推奨...$(NC)"
	@echo "$(CYAN)推奨拡張機能:$(NC)"
	@echo "$(CYAN)  - Bun (oven.bun)$(NC)"
	@echo "$(CYAN)  - TypeScript (ms-vscode.vscode-typescript-next)$(NC)"
	@echo "$(CYAN)  - Prettier (esbenp.prettier-vscode)$(NC)"
	@echo "$(CYAN)  - ESLint (dbaeumer.vscode-eslint)$(NC)"
	@echo "$(CYAN)  - React (ms-vscode.vscode-react)$(NC)"
	@echo "$(GREEN)✅ 開発ツールの確認が完了しました$(NC)"

.PHONY: setup-frontend
setup-frontend: ## フロントエンド環境をセットアップ
	@echo "$(BLUE)🔧 フロントエンド環境をセットアップ中...$(NC)"
	@cd $(FRONTEND_DIR) && \
		echo "$(YELLOW)📦 フロントエンド依存関係をインストール中...$(NC)" && \
		bun install && \
		echo "$(YELLOW)⚙️  環境変数ファイルを作成中...$(NC)" && \
		if [ ! -f .env.local ]; then \
			echo "VITE_API_BASE_URL=http://localhost:3000" > .env.local && \
			echo "VITE_APP_NAME=OPRF Client" >> .env.local && \
			echo "VITE_APP_VERSION=$(VERSION)" >> .env.local; \
		fi && \
		echo "$(GREEN)✅ フロントエンドセットアップ完了$(NC)"

.PHONY: setup-docs
setup-docs: ## ドキュメント環境をセットアップ
	@echo "$(BLUE)📚 ドキュメント環境をセットアップ中...$(NC)"
	@if [ ! -d $(DOCS_DIR) ]; then \
		echo "$(YELLOW)📁 ドキュメントディレクトリを作成中...$(NC)" && \
		mkdir -p $(DOCS_DIR); \
	fi
	@echo "$(GREEN)✅ ドキュメント環境セットアップ完了$(NC)"

# 開発関連
.PHONY: dev
dev: ## 開発サーバーを起動（バックエンド + フロントエンド）
	@echo "$(BLUE)🚀 開発サーバーを起動中...$(NC)"
	@echo "$(CYAN)バックエンド: http://localhost:3000$(NC)"
	@echo "$(CYAN)フロントエンド: http://localhost:5173$(NC)"
	@echo "$(CYAN)API ドキュメント: http://localhost:3000/api-docs/$(NC)"
	@echo ""
	@echo "$(YELLOW)Ctrl+C で停止$(NC)"
	@trap 'echo "$(RED)🛑 サーバーを停止中...$(NC)"; exit 0' INT; \
		$(MAKE) dev-backend & \
		$(MAKE) dev-frontend & \
		wait

.PHONY: dev-backend
dev-backend: ## バックエンド開発サーバーのみ起動
	@echo "$(BLUE)🔧 バックエンド開発サーバーを起動中...$(NC)"
	@cd $(BACKEND_DIR) && bun run dev

.PHONY: dev-frontend
dev-frontend: ## フロントエンド開発サーバーのみ起動
	@echo "$(BLUE)🎨 フロントエンド開発サーバーを起動中...$(NC)"
	@cd $(FRONTEND_DIR) && bun run dev

# テスト関連
.PHONY: test
test: test-backend test-frontend ## 全テストを実行
	@echo "$(GREEN)✅ 全テストが完了しました$(NC)"

.PHONY: test-backend
test-backend: ## バックエンドテストを実行
	@echo "$(BLUE)🧪 バックエンドテストを実行中...$(NC)"
	@cd $(BACKEND_DIR) && bun test

.PHONY: test-frontend
test-frontend: ## フロントエンドテストを実行
	@echo "$(BLUE)🧪 フロントエンドテストを実行中...$(NC)"
	@cd $(FRONTEND_DIR) && bun test

.PHONY: test-coverage
test-coverage: ## テストカバレッジを実行
	@echo "$(BLUE)📊 テストカバレッジを実行中...$(NC)"
	@cd $(BACKEND_DIR) && bun test --coverage
	@cd $(FRONTEND_DIR) && bun test --coverage

# ビルド関連
.PHONY: build
build: build-backend build-frontend ## 全プロジェクトをビルド
	@echo "$(GREEN)✅ ビルドが完了しました$(NC)"

.PHONY: build-backend
build-backend: ## バックエンドをビルド
	@echo "$(BLUE)🔧 バックエンドをビルド中...$(NC)"
	@cd $(BACKEND_DIR) && bun run build

.PHONY: build-frontend
build-frontend: ## フロントエンドをビルド
	@echo "$(BLUE)🎨 フロントエンドをビルド中...$(NC)"
	@cd $(FRONTEND_DIR) && bun run build

# 品質管理
.PHONY: lint
lint: lint-backend lint-frontend ## 全プロジェクトのリントを実行
	@echo "$(GREEN)✅ リントが完了しました$(NC)"

.PHONY: lint-backend
lint-backend: ## バックエンドのリントを実行
	@echo "$(BLUE)🔍 バックエンドリントを実行中...$(NC)"
	@cd $(BACKEND_DIR) && bun run lint

.PHONY: lint-frontend
lint-frontend: ## フロントエンドのリントを実行
	@echo "$(BLUE)🔍 フロントエンドリントを実行中...$(NC)"
	@cd $(FRONTEND_DIR) && bun run lint

.PHONY: format
format: ## コードをフォーマット
	@echo "$(BLUE)🎨 コードをフォーマット中...$(NC)"
	@cd $(BACKEND_DIR) && bun run format
	@cd $(FRONTEND_DIR) && bun run format

# クリーンアップ
.PHONY: clean
clean: clean-backend clean-frontend clean-docs ## 全プロジェクトをクリーンアップ
	@echo "$(GREEN)✅ クリーンアップが完了しました$(NC)"

.PHONY: clean-backend
clean-backend: ## バックエンドをクリーンアップ
	@echo "$(BLUE)🧹 バックエンドをクリーンアップ中...$(NC)"
	@cd $(BACKEND_DIR) && rm -rf node_modules dist build

.PHONY: clean-frontend
clean-frontend: ## フロントエンドをクリーンアップ
	@echo "$(BLUE)🧹 フロントエンドをクリーンアップ中...$(NC)"
	@cd $(FRONTEND_DIR) && rm -rf node_modules dist build

.PHONY: clean-docs
clean-docs: ## ドキュメントをクリーンアップ
	@echo "$(BLUE)🧹 ドキュメントをクリーンアップ中...$(NC)"
	@rm -rf $(DOCS_DIR)/_build

# デプロイメント
.PHONY: deploy
deploy: build ## プロジェクトをデプロイ
	@echo "$(BLUE)🚀 デプロイ中...$(NC)"
	@echo "$(YELLOW)⚠️  デプロイ設定を確認してください$(NC)"

.PHONY: docker-build
docker-build: ## Dockerイメージをビルド
	@echo "$(BLUE)🐳 Dockerイメージをビルド中...$(NC)"
	@docker-compose build

.PHONY: docker-up
docker-up: ## Dockerコンテナを起動
	@echo "$(BLUE)🐳 Dockerコンテナを起動中...$(NC)"
	@docker-compose up -d

.PHONY: docker-down
docker-down: ## Dockerコンテナを停止
	@echo "$(BLUE)🐳 Dockerコンテナを停止中...$(NC)"
	@docker-compose down

# ユーティリティ
.PHONY: status
status: ## プロジェクトの状態を表示
	@echo "$(CYAN)📊 プロジェクト状態$(NC)"
	@echo "$(CYAN)==================$(NC)"
	@echo "$(YELLOW)プロジェクト名:$(NC) $(PROJECT_NAME)"
	@echo "$(YELLOW)バージョン:$(NC) $(VERSION)"
	@echo "$(YELLOW)ビルド時刻:$(NC) $(BUILD_TIME)"
	@echo "$(YELLOW)Git コミット:$(NC) $(GIT_COMMIT)"
	@echo ""
	@echo "$(YELLOW)ディレクトリ構造:$(NC)"
	@ls -la | grep -E "^d" | awk '{print "  " $$9}'

.PHONY: logs
logs: ## ログを表示
	@echo "$(BLUE)📋 ログを表示中...$(NC)"
	@if [ -f $(BACKEND_DIR)/logs/combined.log ]; then \
		tail -f $(BACKEND_DIR)/logs/combined.log; \
	else \
		echo "$(YELLOW)⚠️  ログファイルが見つかりません$(NC)"; \
	fi

# 開発支援
.PHONY: install
install: setup ## setupのエイリアス
	@echo "$(GREEN)✅ インストールが完了しました$(NC)"

.PHONY: start
start: dev ## devのエイリアス
	@echo "$(GREEN)✅ 開発サーバーを起動しました$(NC)"

# 情報表示
.PHONY: info
info: ## プロジェクト情報を表示
	@echo "$(CYAN)📋 OPRF Project Information$(NC)"
	@echo "$(CYAN)==========================$(NC)"
	@echo ""
	@echo "$(YELLOW)プロジェクト名:$(NC) $(PROJECT_NAME)"
	@echo "$(YELLOW)バージョン:$(NC) $(VERSION)"
	@echo "$(YELLOW)ビルド時刻:$(NC) $(BUILD_TIME)"
	@echo "$(YELLOW)Git コミット:$(NC) $(GIT_COMMIT)"
	@echo ""
	@echo "$(YELLOW)技術スタック:$(NC)"
	@echo "  • バックエンド: Bun + TypeScript + Express.js"
	@echo "  • フロントエンド: React + TypeScript + Vite"
	@echo "  • プロトコル: OPRF (Oblivious Pseudorandom Function)"
	@echo ""
	@echo "$(YELLOW)主要機能:$(NC)"
	@echo "  • セキュアなデータ処理"
	@echo "  • RESTful API"
	@echo "  • インタラクティブなUI"
	@echo "  • 包括的なテストスイート"
	@echo ""
	@echo "$(CYAN)詳細情報:$(NC)"
	@echo "  make help    # 利用可能なコマンドを表示"
	@echo "  make setup   # 開発環境をセットアップ"
	@echo "  make dev     # 開発サーバーを起動"
