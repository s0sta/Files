# 📦 ERPNext v15 Installation Scripts - Complete Package

## 📄 الملفات المضمنة:

### 1️⃣ **install_erpnext_v15.sh** (التفاعلي - 393 سطر)
**الأفضل للمبتدئين والتطوير**

```bash
sudo bash install_erpnext_v15.sh
```

✅ **المميزات:**
- تفاعلي - يطلب منك المعلومات المهمة
- يعرض تقدم التثبيت بألوان واضحة
- تسجيل كامل في ملف log
- معالجة أخطاء متقدمة
- رسائل توضيحية لكل خطوة

❓ **يناسب:**
- التثبيت على سيرفر جديد
- المستخدمين اللي بيختارون الإعدادات يدوياً
- الاختبار والتطوير

**الأسئلة التي سيطرحها:**
```
1. Frappe username
2. MySQL password
3. Timezone
4. Site name
```

---

### 2️⃣ **install_erpnext_v15_auto.sh** (تلقائي 100% - 273 سطر)
**الأفضل للتثبيت السريع جداً**

```bash
sudo bash install_erpnext_v15_auto.sh
```

✅ **المميزات:**
- بدون أي أسئلة أو تفاعل
- قيم افتراضية جاهزة
- أسرع بكثير
- مناسب للـ automation و scripting

⚙️ **التكوين (عدل قبل التشغيل):**
```bash
FRAPPE_USER="frappe"
MYSQL_ROOT_PASSWORD="Pass@123"
TIMEZONE="Asia/Riyadh"
SITE_NAME="site1.local"
```

❓ **يناسب:**
- التثبيت المتكرر على عدة سيرفرات
- استخدام في Docker/Kubernetes
- بيئات الـ CI/CD
- المستخدمين اللي عندهم متطلبات موحدة

---

### 3️⃣ **README_AR.md** (دليل كامل - 7.1 KB)
**شرح تفصيلي باللغة العربية**

📖 **المحتوى:**
- نظرة عامة عن السكريبت
- المتطلبات
- الخطوات السريعة
- ماذا يفعل السكريبت؟
- المسارات المهمة
- الأوامر المفيدة
- استكشاف الأخطاء
- نصائح الأمان
- أسئلة شائعة

---

### 4️⃣ **QUICK_START.md** (نسخة مختصرة جداً - 1.5 KB)
**للـ TLDR (Too Long; Didn't Read)**

⚡ **فقط 3 أوامر:**
```bash
wget ...
chmod +x ...
sudo bash ...
```

---

## 🆚 جدول المقارنة:

| المعيار | التفاعلي | التلقائي |
|--------|---------|---------|
| **التفاعل** | ✅ يسأل | ❌ بدون أسئلة |
| **السرعة** | بطيء قليلاً | ⚡ سريع جداً |
| **سهولة الاستخدام** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **المرونة** | عالية | منخفضة |
| **الأمان** | يختار كلمات مرور | قيم افتراضية |
| **للمبتدئين** | ✅ أفضل | ⚠️ أقل |
| **للـ Automation** | ❌ | ✅ أفضل |
| **الحجم** | 13 KB | 8.4 KB |
| **الأسطر** | 393 | 273 |

---

## 🚀 أي واحد أختار؟

### اختر التفاعلي إذا:
- ✅ أول مرة تثبت ERPNext
- ✅ تريد التحكم الكامل في الإعدادات
- ✅ لا تعرف القيم الافتراضية
- ✅ تريد فهم ما يحدث في كل خطوة

### اختر التلقائي إذا:
- ⚡ تريد سرعة قصوى
- 🤖 تثبت على عدة سيرفرات متشابهة
- 🐳 تستخدم Docker/Kubernetes
- 🔄 تريد automation

---

## 📋 خطوات التثبيت (المسار التفاعلي):

```bash
# 1. Download
wget https://your-domain.com/install_erpnext_v15.sh

# 2. Make executable
chmod +x install_erpnext_v15.sh

# 3. Run (as root or with sudo)
sudo bash install_erpnext_v15.sh

# 4. Answer the questions
# - Frappe username: erpnext
# - MySQL password: MySecurePass123
# - Timezone: Asia/Riyadh
# - Site name: site1.local

# 5. Wait... ☕ (30-60 minutes)

# 6. Access at: http://SERVER_IP:80
#    User: Administrator
#    Password: admin
```

---

## 📋 خطوات التثبيت (المسار التلقائي):

```bash
# 1. Download
wget https://your-domain.com/install_erpnext_v15_auto.sh

# 2. Edit configuration (optional)
nano install_erpnext_v15_auto.sh
# Change:
#  - FRAPPE_USER
#  - MYSQL_ROOT_PASSWORD
#  - TIMEZONE
#  - SITE_NAME

# 3. Make executable
chmod +x install_erpnext_v15_auto.sh

# 4. Run (no prompts!)
sudo bash install_erpnext_v15_auto.sh

# 5. Wait... ☕ (30-60 minutes)

# 6. Access at: http://SERVER_IP:80
```

---

## 📂 بنية المجلد:

```
📦 ERPNext_Installation_Scripts/
├── 📄 install_erpnext_v15.sh           ⭐ التفاعلي
├── 📄 install_erpnext_v15_auto.sh      ⚡ التلقائي
├── 📄 README_AR.md                     📖 الدليل الكامل
├── 📄 QUICK_START.md                   ⚡ البدء السريع
└── 📄 FILES_GUIDE.md                   📋 هذا الملف
```

---

## ✅ ماذا يثبت كل سكريبت؟

### المتطلبات:
- ✅ Git
- ✅ Python 3.10
- ✅ MariaDB
- ✅ Redis
- ✅ Node.js 18
- ✅ NPM & Yarn

### البرامج:
- ✅ Frappe Framework v15
- ✅ ERPNext v15
- ✅ Payments App
- ✅ HRMS (HR Management)

### الإعداد:
- ✅ موقع جديد
- ✅ تأمين MySQL
- ✅ تكوين NGINX
- ✅ Supervisor لـ background tasks
- ✅ Firewall rules

---

## 🔐 الأمان:

### كلمات المرور الافتراضية:

| الخدمة | المستخدم | الكلمة |
|--------|---------|-------|
| ERPNext | Administrator | admin |
| MySQL | root | (تحددها أنت) |

⚠️ **IMPORTANT:**
```bash
# غير كلمة مرور ERPNext فوراً بعد الدخول!
# في Settings → Users → Administrator
```

---

## 🔧 الأوامر المهمة بعد التثبيت:

```bash
# دخول مجلد Bench
cd /home/[username]/frappe-bench/

# بدء خادم التطوير
bench start

# إعادة تشغيل الخدمات
bench restart

# فحص الحالة
bench status

# نسخة احتياطية
bench backup

# تحديث النظام
bench update

# مشاهدة السجل
bench logs
```

---

## 📝 ملفات السجل:

```bash
# المسار:
/var/log/erpnext_install_[date].log

# مثال:
/var/log/erpnext_install_06-06-2026_20-45-30.log

# عرض السجل:
cat /var/log/erpnext_install_*.log
tail -100 /var/log/erpnext_install_*.log
```

---

## ❓ أسئلة شائعة:

**س: أي سكريبت أختار؟**  
ج: إذا أول مرة → التفاعلي. إذا تثبت متكرر → التلقائي.

**س: كم وقت التثبيت؟**  
ج: 30-60 دقيقة (حسب سرعة الإنترنت)

**س: هل يمكن استخدام هذه على Linode/DigitalOcean؟**  
ج: نعم! أي سيرفر Linux جديد.

**س: ماذا لو حدث خطأ؟**  
ج: شوف ملف السجل واقرأ الخطأ. معظم الأخطاء قابلة للإصلاح.

---

## 🎯 المسار الموصى به:

### للتطوير المحلي (VirtualBox):
```bash
1. Download التفاعلي
2. تشغيل على VM
3. الاختبار والتطوير
4. جرب الميزات
```

### للـ Production:
```bash
1. Download التفاعلي أو التلقائي
2. تشغيل على VPS (Hetzner/DigitalOcean)
3. إعداد SSL Certificate
4. تفعيل Backups
5. إضافة العملاء
```

---

## 🆘 استكشاف الأخطاء:

### الخطأ: Permission Denied
```bash
# الحل:
chmod +x install_erpnext_v15.sh
```

### الخطأ: MySQL Connection Error
```bash
# الحل:
sudo service mysql restart
```

### الخطأ: Nginx 502 Bad Gateway
```bash
# الحل:
sudo supervisorctl restart all
bench restart
```

---

## 📚 المراجع:

- [الدليل الأصلي](https://discuss.frappe.io/t/guide-how-to-install-erpnext-v15-on-linux-ubuntu-step-by-step-instructions/111706)
- [وثائق ERPNext](https://docs.erpnext.com)
- [مجتمع Frappe](https://discuss.frappe.io)

---

## 📞 الدعم:

إذا واجهت مشاكل:

1. **افحص السجل:**
   ```bash
   tail -50 /var/log/erpnext_install_*.log
   ```

2. **اطلب مساعدة:**
   - Frappe Forum
   - GitHub Issues
   - Stack Overflow

---

## 🎉 ملخص سريع:

| الملف | الاستخدام | الأمر |
|------|-----------|-------|
| install_erpnext_v15.sh | تفاعلي | `sudo bash install_erpnext_v15.sh` |
| install_erpnext_v15_auto.sh | تلقائي | `sudo bash install_erpnext_v15_auto.sh` |
| README_AR.md | شرح مفصل | `less README_AR.md` |
| QUICK_START.md | نسخة مختصرة | `less QUICK_START.md` |

---

**نسخة:** 1.0  
**التاريخ:** يونيو 2026  
**الحالة:** ✅ يعمل ومختبر  

**Happy ERPing! 🚀✨**
