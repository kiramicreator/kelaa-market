# نشر Kelaa Market على Vercel

المشروع مُجهّز مسبقًا للنشر على Vercel (`nitro({ preset: "vercel" })` في
`vite.config.ts`). خطوات النشر:

## 1) ارفع المشروع على GitHub ثم اربطه بـ Vercel
- أنشئ مستودع جديد على GitHub وارفع كل الملفات (ما عدا `node_modules`).
- من [vercel.com](https://vercel.com) اختر **Add New Project** واستورد المستودع.
- Vercel سيكتشف تلقائيًا أنه مشروع Vite ويشغّل `npm run build`.

## 2) قاعدة البيانات (Postgres)
التطبيق يحتاج Postgres حقيقي عند النشر (بدون هذا لن يعمل تسجيل الدخول أو حفظ
الإعلانات). أسهل خيار مجاني متكامل مع Vercel هو **Vercel Postgres** أو
**Neon** (neon.com، له خطة مجانية). أنشئ قاعدة بيانات وخذ رابط الاتصال
(`postgres://...`).

في إعدادات المشروع على Vercel → **Environment Variables** أضف:

| المتغير | القيمة |
|---|---|
| `DATABASE_URL` | رابط اتصال Postgres |
| `BETTER_AUTH_URL` | رابط موقعك الفعلي، مثلًا `https://yourapp.vercel.app` |
| `BETTER_AUTH_SECRET` | نص عشوائي طويل وسرّي (32+ حرف) |
| `VITE_AUTH_ENABLED` | `true` |

تسجيل الدخول بالبريد وكلمة المرور يعمل تلقائيًا بمجرد ضبط هذه المتغيرات. أزرار
Google وX أصبحت الآن مبنية على OAuth حقيقي ومستقل (وليس على أي خدمة تابعة
لمنصة Grok) — راجع القسم التالي لتفعيلها.

## 3) تسجيل الدخول عبر Google وX (اختياري)
كل زر يعمل فقط إذا ضبطت بيانات اعتماد OAuth الخاصة به على Vercel. زر بلا
بيانات اعتماد يبقى ظاهرًا لكن الضغط عليه يعطي رسالة خطأ.

### Google
1. اذهب إلى [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
2. أنشئ **OAuth client ID** من نوع **Web application**.
3. في **Authorized redirect URIs** أضف:
   `https://yourapp.vercel.app/api/auth/callback/google`
   (استبدل الرابط برابط موقعك الفعلي — يجب أن يطابق `BETTER_AUTH_URL` تمامًا).
4. أضف على Vercel:

| المتغير | القيمة |
|---|---|
| `GOOGLE_CLIENT_ID` | Client ID من جوجل |
| `GOOGLE_CLIENT_SECRET` | Client Secret من جوجل |

### X (Twitter)
1. اذهب إلى [X Developer Portal](https://developer.x.com/en/portal/dashboard) وأنشئ تطبيقًا (App) مع **User authentication settings** مفعّلة، نوع **OAuth 2.0**.
2. في **Callback URI / Redirect URL** أضف:
   `https://yourapp.vercel.app/api/auth/callback/twitter`
3. أضف على Vercel:

| المتغير | القيمة |
|---|---|
| `TWITTER_CLIENT_ID` | Client ID من X |
| `TWITTER_CLIENT_SECRET` | Client Secret من X |

> بعد أي تغيير في نطاق الموقع (دومين مخصص مثلًا) حدّث `BETTER_AUTH_URL` ورابط
> الـ Redirect في كل من Google وX معًا، وإلا سيفشل تسجيل الدخول برسالة
> `redirect_uri_mismatch`.

## 4) إرسال بريد التأكيد (SMTP)
تم ربط Better Auth بمرسل بريد عبر SMTP (`src/lib/email/mailer.server.ts`)
يرسل رسالة "تأكيد البريد الإلكتروني" تلقائيًا عند كل تسجيل حساب جديد، ورسالة
"إعادة تعيين كلمة المرور" عند الحاجة.

أضف متغيرات البيئة التالية على Vercel (تصلح مع أي مزوّد SMTP: Gmail، Resend،
SendGrid، Brevo، Mailgun، أو SMTP الخاص باستضافتك):

| المتغير | مثال |
|---|---|
| `SMTP_HOST` | `smtp.gmail.com` |
| `SMTP_PORT` | `587` |
| `SMTP_USER` | بريدك أو اسم مستخدم SMTP |
| `SMTP_PASS` | كلمة مرور التطبيق (App Password) أو مفتاح API |
| `SMTP_FROM` | `Kelaa Market <no-reply@yourdomain.com>` |

بدون هذه المتغيرات، الموقع يعمل بشكل طبيعي لكن رسائل التأكيد تُسجَّل فقط في
سجلات الخادم (Logs) ولا تُرسل فعليًا.

> **Gmail:** فعّل "التحقق بخطوتين" على الحساب ثم أنشئ "App Password" من إعدادات
> جوجل، واستخدمه كـ `SMTP_PASS` (وليس كلمة مرور Gmail العادية).

## 5) إعلانات Google AdSense
تمت إضافة سكربت AdSense ووحدات إعلانية في الصفحة الرئيسية وصفحة تفاصيل
الإعلان. بعد قبول موقعك في AdSense، أضف:

| المتغير | مثال |
|---|---|
| `VITE_ADSENSE_CLIENT_ID` | `ca-pub-1234567890123456` |
| `VITE_ADSENSE_SLOT_HOME` | رقم وحدة الإعلان في الصفحة الرئيسية |
| `VITE_ADSENSE_SLOT_LISTING` | رقم وحدة الإعلان في صفحة تفاصيل الإعلان |

بدون `VITE_ADSENSE_CLIENT_ID` لن يظهر أي إعلان ولن يتأثر عمل الموقع.

## 6) بعد إضافة أي متغير بيئة
اضغط **Redeploy** من لوحة Vercel حتى تُطبَّق المتغيرات الجديدة.
