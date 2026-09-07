const fs = require('fs');
const path = require('path');

const {
  initializeApp,
  applicationDefault,
} = require('firebase-admin/app');

const {
  getFirestore,
  FieldValue,
} = require('firebase-admin/firestore');

// ==========================================
// KONFIGURASI FIREBASE
// ==========================================

const PROJECT_ID = 'daftartugas-e46e9';

initializeApp({
  credential: applicationDefault(),
  projectId: PROJECT_ID,
});

const db = getFirestore();

// ==========================================
// FUNGSI UTAMA SEED FIRESTORE
// ==========================================

async function seedFirestore() {
  try {
    console.log('');
    console.log('===================================');
    console.log('SEED FIRESTORE - SERAWAI LEARNING');
    console.log('===================================');
    console.log('');

    // ======================================
    // 1. LOKASI FILE JSON
    // ======================================

    const jsonPath = path.join(
      __dirname,
      'seed_data.json'
    );

    if (!fs.existsSync(jsonPath)) {
      throw new Error(
        `File seed_data.json tidak ditemukan di: ${jsonPath}`
      );
    }

    console.log(
      '✓ File seed_data.json ditemukan'
    );

    // ======================================
    // 2. BACA FILE JSON
    // ======================================

    const rawData = fs.readFileSync(
      jsonPath,
      'utf8'
    );

    let data;

    try {
      data = JSON.parse(rawData);
    } catch (jsonError) {
      throw new Error(
        `Format JSON tidak valid: ${jsonError.message}`
      );
    }

    console.log(
      '✓ File JSON berhasil dibaca'
    );

    // ======================================
    // 3. VALIDASI DATA UTAMA
    // ======================================

    if (!data) {
      throw new Error(
        'Data JSON kosong.'
      );
    }

    // --------------------------------------
    // VALIDASI CATEGORIES
    // --------------------------------------

    if (!Array.isArray(data.categories)) {
      throw new Error(
        'Properti "categories" harus berupa array.'
      );
    }

    if (data.categories.length === 0) {
      throw new Error(
        'Dataset categories masih kosong.'
      );
    }

    // --------------------------------------
    // VALIDASI PANTUN
    // --------------------------------------

    if (!Array.isArray(data.pantun)) {
      throw new Error(
        'Properti "pantun" harus berupa array.'
      );
    }

    if (data.pantun.length === 0) {
      throw new Error(
        'Dataset pantun masih kosong.'
      );
    }

    console.log(
      `✓ Ditemukan ${data.categories.length} kategori`
    );

    console.log(
      `✓ Ditemukan ${data.pantun.length} pantun`
    );

    console.log('');

    // ======================================
    // 4. BULK WRITER
    // ======================================

    const writer = db.bulkWriter();

    let categoryCount = 0;
    let pantunCount = 0;
    let questionCount = 0;
    let vocabularyCount = 0;

    // ======================================
    // ERROR HANDLER BULK WRITER
    // ======================================

    writer.onWriteError((error) => {
      console.error('');
      console.error(
        `✗ Gagal menulis: ${error.documentRef.path}`
      );

      console.error(
        `  Error: ${error.message}`
      );

      if (error.failedAttempts < 3) {
        console.log(
          `  Mencoba kembali... (${error.failedAttempts}/3)`
        );

        return true;
      }

      return false;
    });

    // ======================================
    // SUCCESS HANDLER
    // ======================================

    writer.onWriteResult(
      (documentRef) => {
        console.log(
          `✓ Berhasil: ${documentRef.path}`
        );
      }
    );

    // ======================================
    // 5. SIMPAN CATEGORIES
    // ======================================

    console.log('');
    console.log(
      '==================================='
    );
    console.log(
      'MEMPROSES CATEGORIES'
    );
    console.log(
      '==================================='
    );

    for (const category of data.categories) {
      // ------------------------------------
      // VALIDASI CATEGORY ID
      // ------------------------------------

      if (!category.id) {
        throw new Error(
          'Setiap category wajib memiliki field "id".'
        );
      }

      // ------------------------------------
      // VALIDASI ORDER
      // ------------------------------------

      if (
        category.order === undefined ||
        category.order === null
      ) {
        throw new Error(
          `Category ${category.id} wajib memiliki field "order".`
        );
      }

      // ------------------------------------
      // VALIDASI NAMA
      // ------------------------------------

      if (!category.nama) {
        throw new Error(
          `Category ${category.id} wajib memiliki field "nama".`
        );
      }

      // ------------------------------------
      // VALIDASI TOTAL PANTUN
      // ------------------------------------

      if (
        category.totalPantun === undefined ||
        category.totalPantun === null
      ) {
        throw new Error(
          `Category ${category.id} wajib memiliki field "totalPantun".`
        );
      }

      console.log('');
      console.log(
        `Memproses kategori: ${category.id}`
      );

      const {
        id,
        ...categoryData
      } = category;

      const categoryRef = db
        .collection('categories')
        .doc(id);

      writer.set(
        categoryRef,
        {
          ...categoryData,

          id,

          updatedAt:
            FieldValue.serverTimestamp(),
        },
        {
          merge: true,
        }
      );

      categoryCount++;
    }

    // ======================================
    // 6. SIMPAN PANTUN
    // ======================================

    console.log('');
    console.log(
      '==================================='
    );
    console.log(
      'MEMPROSES PANTUN'
    );
    console.log(
      '==================================='
    );

    for (const pantun of data.pantun) {
      // ------------------------------------
      // VALIDASI ID PANTUN
      // ------------------------------------

      if (!pantun.id) {
        throw new Error(
          'Setiap pantun wajib memiliki field "id".'
        );
      }

      // ------------------------------------
      // VALIDASI CATEGORY ID
      // ------------------------------------

      if (!pantun.categoryId) {
        throw new Error(
          `Pantun ${pantun.id} wajib memiliki field "categoryId".`
        );
      }

      // ------------------------------------
      // VALIDASI CATEGORY
      // ------------------------------------

      const categoryExists =
        data.categories.some(
          (category) =>
            category.id ===
            pantun.categoryId
        );

      if (!categoryExists) {
        throw new Error(
          `Pantun ${pantun.id} menggunakan categoryId `
          + `"${pantun.categoryId}" tetapi kategori tersebut `
          + 'tidak ditemukan pada data.categories.'
        );
      }

      // ------------------------------------
      // VALIDASI ORDER DALAM CATEGORY
      // ------------------------------------

      if (
        pantun.orderInCategory === undefined ||
        pantun.orderInCategory === null
      ) {
        throw new Error(
          `Pantun ${pantun.id} wajib memiliki field "orderInCategory".`
        );
      }

      console.log('');
      console.log(
        `Memproses pantun: ${pantun.id}`
      );

      console.log(
        `Kategori: ${pantun.categoryId}`
      );

      // ------------------------------------
      // PISAHKAN SUBCOLLECTION
      // ------------------------------------

      const {
        questions = [],
        vocabulary: vocabularies = [],
        ...pantunData
      } = pantun;

      // ------------------------------------
      // VALIDASI QUESTIONS
      // ------------------------------------

      if (!Array.isArray(questions)) {
        throw new Error(
          `"questions" pada ${pantun.id} harus berupa array.`
        );
      }

      // ------------------------------------
      // VALIDASI VOCABULARY
      // ------------------------------------

      if (!Array.isArray(vocabularies)) {
        throw new Error(
          `"vocabulary" pada ${pantun.id} harus berupa array.`
        );
      }

      // ====================================
      // 7. SIMPAN DOCUMENT PANTUN
      // ====================================

      const pantunRef = db
        .collection('pantun')
        .doc(pantun.id);

      writer.set(
        pantunRef,
        {
          ...pantunData,

          id: pantun.id,

          updatedAt:
            FieldValue.serverTimestamp(),
        },
        {
          merge: true,
        }
      );

      pantunCount++;

      // ====================================
      // 8. SIMPAN QUESTIONS
      // ====================================

      for (const question of questions) {
        if (!question.id) {
          throw new Error(
            `Question pada ${pantun.id} tidak memiliki field "id".`
          );
        }

        // ----------------------------------
        // VALIDASI TEMPLATE
        // ----------------------------------

        if (!question.template) {
          throw new Error(
            `Question ${question.id} pada ${pantun.id} `
            + 'tidak memiliki field "template".'
          );
        }

        // ----------------------------------
        // VALIDASI REFERENCE ANSWER
        // ----------------------------------

        if (!question.referenceAnswer) {
          throw new Error(
            `Question ${question.id} pada ${pantun.id} `
            + 'tidak memiliki field "referenceAnswer".'
          );
        }

        // ----------------------------------
        // VALIDASI OPTIONS
        // ----------------------------------

        if (!Array.isArray(question.options)) {
          throw new Error(
            `Field "options" pada ${question.id} `
            + 'harus berupa array.'
          );
        }

        if (question.options.length === 0) {
          throw new Error(
            `Question ${question.id} belum memiliki pilihan jawaban.`
          );
        }

        // Pastikan jawaban referensi
        // tersedia di dalam options
        if (
          !question.options.includes(
            question.referenceAnswer
          )
        ) {
          throw new Error(
            `referenceAnswer "${question.referenceAnswer}" `
            + `pada ${question.id} tidak ditemukan di options.`
          );
        }

        const questionRef = pantunRef
          .collection('questions')
          .doc(question.id);

        writer.set(
          questionRef,
          {
            ...question,

            pantunId:
              pantun.id,

            categoryId:
              pantun.categoryId,

            updatedAt:
              FieldValue.serverTimestamp(),
          },
          {
            merge: true,
          }
        );

        questionCount++;
      }

      // ====================================
      // 9. SIMPAN VOCABULARY
      // ====================================

      for (
        const vocabularyItem
        of vocabularies
      ) {
        if (!vocabularyItem.id) {
          throw new Error(
            `Vocabulary pada ${pantun.id} tidak memiliki field "id".`
          );
        }

        if (!vocabularyItem.serawai) {
          throw new Error(
            `Vocabulary ${vocabularyItem.id} `
            + `pada ${pantun.id} tidak memiliki field "serawai".`
          );
        }

        if (!vocabularyItem.indonesia) {
          throw new Error(
            `Vocabulary ${vocabularyItem.id} `
            + `pada ${pantun.id} tidak memiliki field "indonesia".`
          );
        }

        const vocabularyRef =
          pantunRef
            .collection('vocabulary')
            .doc(
              vocabularyItem.id
            );

        writer.set(
          vocabularyRef,
          {
            ...vocabularyItem,

            pantunId:
              pantun.id,

            categoryId:
              pantun.categoryId,

            updatedAt:
              FieldValue.serverTimestamp(),
          },
          {
            merge: true,
          }
        );

        vocabularyCount++;
      }
    }

    // ======================================
    // 10. TUNGGU SEMUA WRITE
    // ======================================

    console.log('');
    console.log(
      'Menunggu proses penulisan '
      + 'ke Firestore...'
    );

    await writer.close();

    // ======================================
    // 11. HASIL IMPORT
    // ======================================

    console.log('');
    console.log(
      '==================================='
    );

    console.log(
      'IMPORT BERHASIL'
    );

    console.log(
      '==================================='
    );

    console.log(
      `Categories : ${categoryCount}`
    );

    console.log(
      `Pantun     : ${pantunCount}`
    );

    console.log(
      `Questions  : ${questionCount}`
    );

    console.log(
      `Vocabulary : ${vocabularyCount}`
    );

    console.log(
      '==================================='
    );

    console.log('');

    console.log(
      'Silakan cek Firebase Console '
      + '> Firestore Database > Data'
    );

    console.log('');

    console.log(
      'Struktur yang diharapkan:'
    );

    console.log('');

    console.log(
      'categories/'
    );

    console.log(
      '  category_01'
    );

    console.log(
      '  category_02'
    );

    console.log(
      '  category_03'
    );

    console.log('');

    console.log(
      'pantun/'
    );

    console.log(
      '  pantun_001/'
    );

    console.log(
      '    questions/'
    );

    console.log(
      '    vocabulary/'
    );

    console.log('');

    process.exit(0);

  } catch (error) {
    console.error('');

    console.error(
      '==================================='
    );

    console.error(
      'IMPORT GAGAL'
    );

    console.error(
      '==================================='
    );

    console.error(
      error.message || error
    );

    console.error('');

    process.exit(1);
  }
}

// ==========================================
// JALANKAN
// ==========================================

seedFirestore();