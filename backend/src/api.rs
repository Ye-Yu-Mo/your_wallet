use axum::{
    extract::{Path, Query, State},
    http::StatusCode,
    response::Json,
    routing::{get, post, put, delete},
    Router,
};
use uuid::Uuid;
use std::sync::Arc;
use chrono::Utc;

use crate::models::*;
use crate::services::AppState;

pub fn create_api_router() -> Router<Arc<AppState>> {
    Router::new()
        // 用户相关路由
        .route("/users", post(create_user))
        .route("/users/:id", get(get_user))
        
        // 账户相关路由
        .route("/accounts", get(get_accounts))
        .route("/accounts", post(create_account))
        .route("/accounts/:id", get(get_account))
        .route("/accounts/:id", put(update_account))
        .route("/accounts/:id", delete(delete_account))
        
        // 交易相关路由
        .route("/transactions", get(get_transactions))
        .route("/transactions", post(create_transaction))
        .route("/transactions/:id", get(get_transaction))
        .route("/transactions/:id", put(update_transaction))
        .route("/transactions/:id", delete(delete_transaction))
        
        // 分类相关路由
        .route("/categories", get(get_categories))
        
        // 统计相关路由
        .route("/summary", get(get_financial_summary))
}

// 用户API处理器
async fn create_user(
    State(_state): State<Arc<AppState>>,
    Json(payload): Json<CreateUserRequest>,
) -> Result<Json<ApiResponse<User>>, StatusCode> {
    // TODO: 实现用户创建逻辑
    let user = User {
        id: Uuid::new_v4(),
        username: payload.username,
        email: payload.email,
        display_name: payload.display_name,
        avatar_url: None,
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(user)))
}

async fn get_user(
    State(_state): State<Arc<AppState>>,
    Path(user_id): Path<Uuid>,
) -> Result<Json<ApiResponse<User>>, StatusCode> {
    // TODO: 从数据库查询用户
    // 暂时返回模拟数据
    let user = User {
        id: user_id,
        username: "demo_user".to_string(),
        email: "demo@example.com".to_string(),
        display_name: "演示用户".to_string(),
        avatar_url: None,
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(user)))
}

// 账户API处理器
async fn get_accounts(
    State(_state): State<Arc<AppState>>,
    Query(pagination): Query<PaginationQuery>,
) -> Result<Json<ApiResponse<PaginatedResponse<Account>>>, StatusCode> {
    // TODO: 从数据库查询账户列表
    // 暂时返回模拟数据
    let accounts = vec![
        Account {
            id: Uuid::new_v4(),
            user_id: Uuid::new_v4(),
            name: "现金账户".to_string(),
            account_type: AccountType::Cash,
            currency: "CNY".to_string(),
            balance: rust_decimal::Decimal::from(5000),
            is_active: true,
            created_at: Utc::now(),
            updated_at: Utc::now(),
        },
        Account {
            id: Uuid::new_v4(),
            user_id: Uuid::new_v4(),
            name: "工商银行卡".to_string(),
            account_type: AccountType::BankCard,
            currency: "CNY".to_string(),
            balance: rust_decimal::Decimal::from(15000),
            is_active: true,
            created_at: Utc::now(),
            updated_at: Utc::now(),
        },
    ];
    
    let page = pagination.page.unwrap_or(1);
    let limit = pagination.limit.unwrap_or(20);
    
    let response = PaginatedResponse {
        data: accounts,
        page,
        limit,
        total: 2,
        has_next: false,
    };
    
    Ok(Json(ApiResponse::success(response)))
}

async fn create_account(
    State(_state): State<Arc<AppState>>,
    Json(payload): Json<CreateAccountRequest>,
) -> Result<Json<ApiResponse<Account>>, StatusCode> {
    // TODO: 实现账户创建逻辑
    let account = Account {
        id: Uuid::new_v4(),
        user_id: Uuid::new_v4(), // TODO: 从认证中获取用户ID
        name: payload.name,
        account_type: payload.account_type,
        currency: payload.currency,
        balance: payload.initial_balance.unwrap_or_default(),
        is_active: true,
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(account)))
}

async fn get_account(
    State(_state): State<Arc<AppState>>,
    Path(account_id): Path<Uuid>,
) -> Result<Json<ApiResponse<Account>>, StatusCode> {
    // TODO: 从数据库查询特定账户
    let account = Account {
        id: account_id,
        user_id: Uuid::new_v4(),
        name: "演示账户".to_string(),
        account_type: AccountType::Cash,
        currency: "CNY".to_string(),
        balance: rust_decimal::Decimal::from(10000),
        is_active: true,
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(account)))
}

async fn update_account(
    State(_state): State<Arc<AppState>>,
    Path(account_id): Path<Uuid>,
    Json(_payload): Json<CreateAccountRequest>,
) -> Result<Json<ApiResponse<Account>>, StatusCode> {
    // TODO: 实现账户更新逻辑
    let account = Account {
        id: account_id,
        user_id: Uuid::new_v4(),
        name: "更新后的账户".to_string(),
        account_type: AccountType::Cash,
        currency: "CNY".to_string(),
        balance: rust_decimal::Decimal::from(10000),
        is_active: true,
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(account)))
}

async fn delete_account(
    State(_state): State<Arc<AppState>>,
    Path(_account_id): Path<Uuid>,
) -> Result<Json<ApiResponse<()>>, StatusCode> {
    // TODO: 实现账户删除逻辑
    Ok(Json(ApiResponse::success(())))
}

// 交易API处理器
async fn get_transactions(
    State(_state): State<Arc<AppState>>,
    Query(pagination): Query<PaginationQuery>,
) -> Result<Json<ApiResponse<PaginatedResponse<Transaction>>>, StatusCode> {
    // TODO: 从数据库查询交易列表
    // 暂时返回模拟数据
    let transactions = vec![
        Transaction {
            id: Uuid::new_v4(),
            user_id: Uuid::new_v4(),
            account_id: Uuid::new_v4(),
            category_id: None,
            transaction_type: TransactionType::Income,
            amount: rust_decimal::Decimal::from(3000),
            currency: "CNY".to_string(),
            description: "工资收入".to_string(),
            notes: None,
            tags: vec!["工资".to_string()],
            transaction_date: Utc::now(),
            created_at: Utc::now(),
            updated_at: Utc::now(),
        },
        Transaction {
            id: Uuid::new_v4(),
            user_id: Uuid::new_v4(),
            account_id: Uuid::new_v4(),
            category_id: None,
            transaction_type: TransactionType::Expense,
            amount: rust_decimal::Decimal::from(500),
            currency: "CNY".to_string(),
            description: "超市购物".to_string(),
            notes: Some("买了生活用品".to_string()),
            tags: vec!["购物".to_string(), "生活".to_string()],
            transaction_date: Utc::now(),
            created_at: Utc::now(),
            updated_at: Utc::now(),
        },
    ];
    
    let page = pagination.page.unwrap_or(1);
    let limit = pagination.limit.unwrap_or(20);
    
    let response = PaginatedResponse {
        data: transactions,
        page,
        limit,
        total: 2,
        has_next: false,
    };
    
    Ok(Json(ApiResponse::success(response)))
}

async fn create_transaction(
    State(_state): State<Arc<AppState>>,
    Json(payload): Json<CreateTransactionRequest>,
) -> Result<Json<ApiResponse<Transaction>>, StatusCode> {
    // TODO: 实现交易创建逻辑
    let transaction = Transaction {
        id: Uuid::new_v4(),
        user_id: Uuid::new_v4(), // TODO: 从认证中获取用户ID
        account_id: payload.account_id,
        category_id: payload.category_id,
        transaction_type: payload.transaction_type,
        amount: payload.amount,
        currency: "CNY".to_string(), // TODO: 从账户获取货币类型
        description: payload.description,
        notes: payload.notes,
        tags: payload.tags.unwrap_or_default(),
        transaction_date: payload.transaction_date.unwrap_or(Utc::now()),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(transaction)))
}

async fn get_transaction(
    State(_state): State<Arc<AppState>>,
    Path(transaction_id): Path<Uuid>,
) -> Result<Json<ApiResponse<Transaction>>, StatusCode> {
    // TODO: 从数据库查询特定交易
    let transaction = Transaction {
        id: transaction_id,
        user_id: Uuid::new_v4(),
        account_id: Uuid::new_v4(),
        category_id: None,
        transaction_type: TransactionType::Expense,
        amount: rust_decimal::Decimal::from(100),
        currency: "CNY".to_string(),
        description: "演示交易".to_string(),
        notes: None,
        tags: vec![],
        transaction_date: Utc::now(),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(transaction)))
}

async fn update_transaction(
    State(_state): State<Arc<AppState>>,
    Path(transaction_id): Path<Uuid>,
    Json(_payload): Json<UpdateTransactionRequest>,
) -> Result<Json<ApiResponse<Transaction>>, StatusCode> {
    // TODO: 实现交易更新逻辑
    let transaction = Transaction {
        id: transaction_id,
        user_id: Uuid::new_v4(),
        account_id: Uuid::new_v4(),
        category_id: None,
        transaction_type: TransactionType::Expense,
        amount: rust_decimal::Decimal::from(200),
        currency: "CNY".to_string(),
        description: "更新后的交易".to_string(),
        notes: None,
        tags: vec![],
        transaction_date: Utc::now(),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };
    
    Ok(Json(ApiResponse::success(transaction)))
}

async fn delete_transaction(
    State(_state): State<Arc<AppState>>,
    Path(_transaction_id): Path<Uuid>,
) -> Result<Json<ApiResponse<()>>, StatusCode> {
    // TODO: 实现交易删除逻辑
    Ok(Json(ApiResponse::success(())))
}

// 分类API处理器
async fn get_categories(
    State(_state): State<Arc<AppState>>,
) -> Result<Json<ApiResponse<Vec<Category>>>, StatusCode> {
    // TODO: 从数据库查询分类列表
    // 暂时返回模拟数据
    let categories = vec![
        Category {
            id: Uuid::new_v4(),
            name: "餐饮".to_string(),
            icon: "restaurant".to_string(),
            color: "#FF9800".to_string(),
            transaction_type: TransactionType::Expense,
            is_system: true,
        },
        Category {
            id: Uuid::new_v4(),
            name: "交通".to_string(),
            icon: "commute".to_string(),
            color: "#2196F3".to_string(),
            transaction_type: TransactionType::Expense,
            is_system: true,
        },
        Category {
            id: Uuid::new_v4(),
            name: "工资".to_string(),
            icon: "work".to_string(),
            color: "#4CAF50".to_string(),
            transaction_type: TransactionType::Income,
            is_system: true,
        },
    ];
    
    Ok(Json(ApiResponse::success(categories)))
}

// 统计API处理器
async fn get_financial_summary(
    State(_state): State<Arc<AppState>>,
) -> Result<Json<ApiResponse<FinancialSummary>>, StatusCode> {
    // TODO: 从数据库计算统计数据
    // 暂时返回模拟数据
    let summary = FinancialSummary {
        total_income: rust_decimal::Decimal::from(10000),
        total_expense: rust_decimal::Decimal::from(6000),
        net_income: rust_decimal::Decimal::from(4000),
        account_balances: vec![
            AccountBalance {
                account_id: Uuid::new_v4(),
                account_name: "现金".to_string(),
                balance: rust_decimal::Decimal::from(5000),
                currency: "CNY".to_string(),
            },
            AccountBalance {
                account_id: Uuid::new_v4(),
                account_name: "银行卡".to_string(),
                balance: rust_decimal::Decimal::from(15000),
                currency: "CNY".to_string(),
            },
        ],
    };
    
    Ok(Json(ApiResponse::success(summary)))
}