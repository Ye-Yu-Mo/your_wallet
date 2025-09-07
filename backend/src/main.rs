use axum::{
    routing::get,
    Router,
    response::Json,
};
use tower_http::cors::CorsLayer;
use std::net::SocketAddr;
use std::sync::Arc;

mod api;
mod models;  
mod services;
// mod db;  // TODO: 待实现数据库功能时启用
// mod utils;  // TODO: 待实现工具函数时启用

use services::{AppState};

#[tokio::main]
async fn main() {
    // 初始化日志
    tracing_subscriber::fmt::init();
    
    // 初始化应用状态
    let state = Arc::new(AppState::new());
    
    // 构建路由
    let app = Router::new()
        .route("/", get(root))
        .route("/health", get(health_check))
        .nest("/api", api::create_api_router())
        .layer(CorsLayer::permissive())
        .with_state(state);
    
    // 启动服务器
    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    println!("🚀 YourWallet Backend server starting on http://{}", addr);
    println!("📋 API文档: http://{}/health", addr);
    println!("🔗 API端点: http://{}/api", addr);
    
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn root() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "message": "Welcome to YourWallet API",
        "version": "0.1.0"
    }))
}

async fn health_check() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "status": "healthy",
        "timestamp": chrono::Utc::now()
    }))
}