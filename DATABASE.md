# DATABASE.md — Budget Tracker

## الجدول: `expenses`
جدول واحد يتذكّر كل مصروف: على شنو صرفت، كم، وأي يوم.

| العمود | النوع | إجباري؟ | ليش موجود |
|---|---|---|---|
| `id` | رقم (يتعبّى تلقائي) | نعم | هوية خاصة لكل صف |
| `created_at` | تاريخ ووقت (تلقائي) | نعم | متى انضاف الصف |
| `category` | نص | نعم | الفئة: Food أو Fuel أو Services. أصفّي بها |
| `amount` | رقم عشري (3 خانات) | نعم | المبلغ بالدينار الكويتي |
| `description` | نص | نعم | على شنو صرفت |
| `spent_on` | تاريخ (الافتراضي اليوم) | نعم | يوم الصرف الفعلي |
| `note` | نص | لا | ملاحظة إضافية اختيارية |

الجدول في Supabase (مشروع `budget-tracker`)، وفيه RLS مفعّل.

## الصفوف (3)
| id | category | amount | description | spent_on |
|---|---|---|---|---|
| 1 | Food | 5.500 | Lunch at Johnny Rockets | 2026-11-02 |
| 2 | Fuel | 10.000 | Fuel fill-up | 2026-11-01 |
| 3 | Services | 50.000 | Phone bill | 2026-10-31 |

## أسئلتي وإجابات Claude
**1. كم صرفت على البنزين (Fuel)؟**
`select sum(amount) from expenses where category = 'Fuel';` → **10.000 د.ك**

**2. شنو أكبر مصروف؟**
`select ... from expenses order by amount desc limit 1;` → **Phone bill (Services) 50.000 د.ك**

الاستعلامات في `sql/03_questions.sql`.
