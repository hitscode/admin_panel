import os
import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from auth import router as auth_router
from students import router as students_router
from db import initialize_admin

app = FastAPI(title="Admin Panel API")

# Allow all origins (for development; restrict in production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# On startup, initialize the admin user
@app.on_event("startup")
async def startup_event():
    initialize_admin()

# Include routers
app.include_router(auth_router)
app.include_router(students_router)

if __name__ == "__main__":
    port = int(os.getenv("PORT", 9090))
    uvicorn.run(app, host="0.0.0.0", port=port)