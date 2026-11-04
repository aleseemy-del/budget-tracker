# DATABASE.md — Budget Tracker

## الجدول: `expenses`
جدول واحد يتذكّر كل عملية مالية: على شنو صرفت (أو من وين دخلك)، كم، وأي يوم، وكل مستخدم يشوف عملياته هو فقط.

| العمود | النوع | إجباري؟ | ليش موجود |
|---|---|---|---|
| `id` | رقم (يتعبّى تلقائي) | نعم | هوية خاصة لكل صف |
| `created_at` | تاريخ ووقت (تلقائي) | نعم | متى انضاف الصف |
| `category` | نص | نعم | التصنيف (مثل `dining` و`transport` و`bills`). أصفّي به |
| `amount` | رقم عشري (3 خانات) | نعم | المبلغ بالدينار الكويتي |
| `description` | نص | نعم | على شنو صرفت (ملاحظة العملية) |
| `spent_on` | تاريخ (الافتراضي اليوم) | نعم | يوم العملية الفعلي |
| `note` | نص | لا | عمود احتياطي للملاحظات (التطبيق يستخدم `description`) |
| `receipt_path` | نص | لا | مسار صورة الفاتورة في الـ bucket `receipts` |
| `user_id` | uuid (يتعبّى تلقائي بالمستخدم) | تلقائي | صاحب العملية. هو اللي يخلّي كل مستخدم يشوف عملياته فقط |
| `type` | نص: `expense` أو `income` | نعم (الافتراضي `expense`) | مصروف أو دخل |
| `payment_method` | نص: `card` أو `cash` أو `transfer` أو `applepay` | لا | طريقة الدفع |

## الأمان
- الجدول في Supabase (مشروع `budget-tracker`) وفيه **RLS** مفعّل.
- القواعد (policies): المستخدم المسجّل يقرأ ويضيف ويعدّل ويحذف صفوفه فقط (`user_id = auth.uid()`).
- الـ bucket `receipts` خاص، وكل مستخدم يرفع ويشوف الصور في مجلد باسم `user_id` حقه فقط. الحد 5 MB وصور فقط.

## الصفوف (3 في البداية)
| id | category | amount | description | spent_on |
|---|---|---|---|---|
| 1 | dining | 5.500 | Lunch at Johnny Rockets | 2026-11-02 |
| 2 | transport | 10.000 | Fuel fill-up | 2026-11-01 |
| 3 | bills | 50.000 | Phone bill | 2026-10-31 |

(كانت الفئات في البداية `Food` و`Fuel` و`Services`، وحوّلتها لتصنيفات التطبيق.)

## أسئلتي وإجابات Claude
**1. كم صرفت على البنزين؟**
`select sum(amount) from expenses where category = 'Fuel';` → **10.000 د.ك**
(الحين التصنيف `transport`)

**2. شنو أكبر مصروف؟**
`select ... from expenses order by amount desc limit 1;` → **Phone bill 50.000 د.ك**

الاستعلامات في `sql/03_questions.sql`، وتغييرات الجدول في `sql/04_receipts_and_auth.sql`.

## التطبيق
`index.html`: واجهة Budget Tracker تتصل بنفس الجدول عبر Supabase مع تسجيل دخول، وتضيف وتعدّل وتحذف العمليات وترفع صور الفواتير.
