from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from nlp_engine import analyze_answer


app = FastAPI(
    title="Serawai NLP API",
    version="1.0.0",
)


# ==========================================
# CORS
# ==========================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==========================================
# REQUEST MODEL
# ==========================================

class AnalyzeRequest(BaseModel):
    template: str
    userAnswer: str
    referenceAnswer: str
    targetRhyme: str


# ==========================================
# ROOT
# ==========================================

@app.get("/")
def root():
    return {
        "status": "ok",
        "message": "Serawai NLP API berjalan",
    }


# ==========================================
# HEALTH CHECK
# ==========================================

@app.get("/health")
def health():
    return {
        "status": "healthy",
    }


# ==========================================
# ANALISIS NLP
# ==========================================

@app.post("/analyze")
def analyze(
    request: AnalyzeRequest,
):
    result = analyze_answer(
        template=request.template,
        user_answer=request.userAnswer,
        reference_answer=request.referenceAnswer,
        target_rhyme=request.targetRhyme,
    )

    return result