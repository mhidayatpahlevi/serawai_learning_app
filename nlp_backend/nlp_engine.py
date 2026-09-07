import re
from typing import Dict

from sentence_transformers import SentenceTransformer
from sentence_transformers.util import cos_sim


# ==========================================
# MODEL NLP
# ==========================================

MODEL_NAME = "paraphrase-multilingual-MiniLM-L12-v2"

print("Memuat model NLP...")

model = SentenceTransformer(MODEL_NAME)

print("Model NLP siap.")


# ==========================================
# NORMALISASI
# ==========================================

def normalize_text(text: str) -> str:
    text = text.lower().strip()

    text = re.sub(
        r"[^\w\s]",
        "",
        text,
        flags=re.UNICODE,
    )

    text = re.sub(
        r"\s+",
        " ",
        text,
    )

    return text


# ==========================================
# SEMANTIC SIMILARITY
# ==========================================

def semantic_similarity(
    user_answer: str,
    reference_answer: str,
) -> float:

    user = normalize_text(user_answer)

    reference = normalize_text(
        reference_answer
    )

    if not user or not reference:
        return 0.0

    # Jawaban identik
    if user == reference:
        return 1.0

    embeddings = model.encode(
        [
            user,
            reference,
        ],
        convert_to_tensor=True,
    )

    similarity = cos_sim(
        embeddings[0],
        embeddings[1],
    ).item()

    # cosine dapat bernilai negatif
    similarity = max(
        0.0,
        min(
            1.0,
            float(similarity),
        ),
    )

    return similarity


# ==========================================
# CONTEXT SIMILARITY
# ==========================================

def context_similarity(
    template: str,
    user_answer: str,
    reference_answer: str,
) -> float:

    if "____" not in template:
        return semantic_similarity(
            user_answer,
            reference_answer,
        )

    user_context = template.replace(
        "____",
        user_answer,
        1,
    )

    reference_context = template.replace(
        "____",
        reference_answer,
        1,
    )

    if (
        normalize_text(user_context)
        ==
        normalize_text(reference_context)
    ):
        return 1.0

    embeddings = model.encode(
        [
            user_context,
            reference_context,
        ],
        convert_to_tensor=True,
    )

    similarity = cos_sim(
        embeddings[0],
        embeddings[1],
    ).item()

    similarity = max(
        0.0,
        min(
            1.0,
            float(similarity),
        ),
    )

    return similarity


# ==========================================
# LONGEST COMMON SUFFIX
# ==========================================

def longest_common_suffix(
    first: str,
    second: str,
) -> int:

    first = normalize_text(first)
    second = normalize_text(second)

    count = 0

    for a, b in zip(
        reversed(first),
        reversed(second),
    ):
        if a != b:
            break

        count += 1

    return count


# ==========================================
# RHYME SCORE
# ==========================================

def rhyme_similarity(
    answer: str,
    target_rhyme: str,
) -> float:

    answer = normalize_text(answer)

    target = normalize_text(
        target_rhyme
    )

    if not answer or not target:
        return 0.0

    # Rima sama persis
    if answer.endswith(target):
        return 1.0

    common = longest_common_suffix(
        answer,
        target,
    )

    score = common / len(target)

    return max(
        0.0,
        min(
            1.0,
            score,
        ),
    )


# ==========================================
# PENJELASAN
# ==========================================

def build_explanation(
    semantic_score: float,
    context_score: float,
    rhyme_score: float,
    is_correct: bool,
) -> str:

    parts = []

    if semantic_score >= 0.80:
        parts.append(
            "maknanya sangat sesuai"
        )
    elif semantic_score >= 0.60:
        parts.append(
            "maknanya cukup sesuai"
        )
    else:
        parts.append(
            "maknanya kurang sesuai"
        )

    if context_score >= 0.80:
        parts.append(
            "sesuai dengan konteks pantun"
        )
    elif context_score >= 0.60:
        parts.append(
            "cukup sesuai dengan konteks pantun"
        )
    else:
        parts.append(
            "kurang sesuai dengan konteks pantun"
        )

    if rhyme_score >= 0.80:
        parts.append(
            "memenuhi pola rima"
        )
    elif rhyme_score >= 0.50:
        parts.append(
            "cukup mendekati pola rima"
        )
    else:
        parts.append(
            "belum sesuai dengan pola rima"
        )

    prefix = (
        "Jawaban dapat diterima karena "
        if is_correct
        else
        "Jawaban belum tepat karena "
    )

    return (
        prefix
        + ", ".join(parts)
        + "."
    )


# ==========================================
# ANALISIS UTAMA
# ==========================================

def analyze_answer(
    template: str,
    user_answer: str,
    reference_answer: str,
    target_rhyme: str,
) -> Dict:

    semantic_score = semantic_similarity(
        user_answer,
        reference_answer,
    )

    context_score = context_similarity(
        template,
        user_answer,
        reference_answer,
    )

    rhyme_score = rhyme_similarity(
        user_answer,
        target_rhyme,
    )

    # ======================================
    # BOBOT
    # ======================================

    semantic_weight = 0.45
    context_weight = 0.35
    rhyme_weight = 0.20

    final_score = (
        semantic_score
        * semantic_weight
        +
        context_score
        * context_weight
        +
        rhyme_score
        * rhyme_weight
    )

    # ======================================
    # THRESHOLD
    # ======================================

    threshold = 0.75

    is_correct = (
        final_score >= threshold
    )

    # Jawaban referensi harus diterima
    if (
        normalize_text(user_answer)
        ==
        normalize_text(reference_answer)
    ):
        semantic_score = 1.0
        context_score = 1.0

        final_score = (
            semantic_score
            * semantic_weight
            +
            context_score
            * context_weight
            +
            rhyme_score
            * rhyme_weight
        )

        is_correct = True

    explanation = build_explanation(
        semantic_score,
        context_score,
        rhyme_score,
        is_correct,
    )

    return {
        "semanticScore": round(
            semantic_score,
            4,
        ),
        "contextScore": round(
            context_score,
            4,
        ),
        "rhymeScore": round(
            rhyme_score,
            4,
        ),
        "finalScore": round(
            final_score,
            4,
        ),
        "isCorrect": is_correct,
        "explanation": explanation,
    }