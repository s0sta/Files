# 🚀 ERPNext v15 Automated Installation Script

## نظرة عامة
هذا السكريبت يقوم بتثبيت ERPNext v15 بشكل **تلقائي كامل** على Ubuntu 22.04 LTS دون الحاجة لإدخال أوامر يدوية.

---

## ✅ المتطلبات

- **نظام التشغيل:** Ubuntu 22.04 LTS (أو أحدث)
- **الموارد:** CPU 2 كور + RAM 4GB + Disk 20GB (حد أدنى)
- **الوصول:** صلاحيات root أو sudo
- **الإنترنت:** اتصال مستقر (التثبيت قد يأخذ 30-60 دقيقة)

---

## 🎯 الخطوات السريعة

### 1️⃣ تحميل السكريبت

```bash
# على السيرفر الخاص بك أو VM
wget https://your-server.com/install_erpnext_v15.sh
# أو انسخ الملف مباشرة
```

### 2️⃣ جعل السكريبت قابل للتنفيذ

```bash
chmod +x install_erpnext_v15.sh
```

### 3️⃣ تشغيل التثبيت

```bash
sudo bash install_erpnext_v15.sh
```

### 4️⃣ أجب على الأسئلة

السكريبت سيطلب منك:
- **اسم مستخدم Frappe:** (افتراضي: frappe)
- **كلمة مرور MySQL:** (اختياري)
- **المنطقة الزمنية:** (افتراضي: Asia/Riyadh)
- **اسم الموقع:** (افتراضي: site1.local)

مثال:

```
Enter Frappe username (default: frappe): erpnext_user
Enter MySQL root password: MySecurePassword123
Enter timezone (default: Asia/Riyadh): Asia/Riyadh
Enter site name (default: site1.local): mysite.local
```

### 5️⃣ اجلس واشرب القهوة ☕

السكريبت سينفذ كل شيء تلقائياً!

---

## 📋 ماذا يفعل السكريبت؟

### ✔️ الخطوة 1: إعداد الخادم
- تعيين المنطقة الزمنية
- إنشاء مستخدم Frappe جديد
- تحديث نظام الحزم

### ✔️ الخطوة 2: تثبيت المتطلبات
- Git
- Python 3.10
- MariaDB
- Redis
- Node.js 18
- NPM و Yarn
- مكتبات PDF والخطوط

### ✔️ الخطوة 3: تكوين MySQL
- تأمين قاعدة البيانات
- تعيين أحرف UTF-8

### ✔️ الخطوة 4: إعداد Frappe Bench
- تثبيت Frappe CLI
- إنشاء بيئة Frappe
- إنشاء موقع جديد

### ✔️ الخطوة 5: تثبيت التطبيقات
- ERPNext v15
- Payment Gateway
- HRMS (إدارة الموارد البشرية)

### ✔️ الخطوة 6: إعداد الإنتاج
- تفعيل Scheduler
- تكوين NGINX
- إعداد Supervisor
- تشغيل Firewall

---

## 🌐 الوصول إلى ERPNext

بعد انتهاء التثبيت:

### في نفس الخادم:
```
http://localhost:80
```

### من جهاز آخر:
```
http://[SERVER_IP]:80
```

### الأوامر الافتراضية:
- **Username:** Administrator
- **Password:** admin

⚠️ **تنبيه:** غير كلمة المرور فوراً بعد أول دخول!

---

## 📂 مسارات مهمة

| المسار | الوصف |
|--------|-------|
| `/home/erpnext_user/frappe-bench/` | مجلد Frappe الرئيسي |
| `/var/log/erpnext_install_*.log` | ملف السجل |
| `/etc/nginx/sites-enabled/` | إعدادات NGINX |
| `/etc/supervisor/conf.d/` | إعدادات Supervisor |

---

## 🔧 الأوامر المفيدة بعد التثبيت

### البدء بخادم التطوير:
```bash
cd /home/frappe_user/frappe-bench/
bench start
```

### إعادة تشغيل الخدمات:
```bash
bench restart
```

### عرض حالة النظام:
```bash
bench status
```

### تحديث ERPNext:
```bash
bench update
```

### النسخ الاحتياطي:
```bash
bench backup
```

---

## ❌ استكشاف الأخطاء

### المشكلة: "Permission denied"
```bash
# الحل:
sudo chmod +x install_erpnext_v15.sh
```

### المشكلة: "MySQL connection error"
```bash
# الحل:
sudo service mysql restart
```

### المشكلة: "Nginx 502 Bad Gateway"
```bash
# الحل:
sudo supervisorctl restart all
bench restart
```

### المشكلة: الحصول على السجل الكامل
```bash
# عرض ملف السجل:
cat /var/log/erpnext_install_*.log

# الجزء الأخير:
tail -f /var/log/erpnext_install_*.log
```

---

## 🔐 نصائح الأمان

1. **غيّر كلمة المرور الافتراضية** فوراً
2. **استخدم HTTPS** (SSL Certificate):
   ```bash
   sudo certbot --nginx
   ```

3. **فعّل جدار الحماية:**
   ```bash
   sudo ufw enable
   ```

4. **نسخ احتياطي دوري:**
   ```bash
   bench backup
   ```

5. **حدّث النظام بانتظام:**
   ```bash
   bench update
   ```

---

## 📊 ملف السجل

يتم حفظ كل خطوة تثبيت في ملف السجل:
```bash
/var/log/erpnext_install_[date_time].log
```

**يفيد في:**
- تتبع التثبيت
- استكشاف الأخطاء
- مراجعة الأداء

---

## 🚀 الخطوات التالية بعد التثبيت

1. ✅ **تسجيل الدخول:** استخدم admin/admin
2. ✅ **تغيير كلمة المرور**
3. ✅ **إنشاء شركتك الأولى**
4. ✅ **إضافة المستخدمين**
5. ✅ **تكوين الوحدات:** مبيعات، مشتريات، محاسبة، إلخ
6. ✅ **إعداد SSL Certificate**

---

## 📚 موارد مفيدة

- [وثائق ERPNext الرسمية](https://docs.erpnext.com)
- [مجتمع Frappe](https://discuss.frappe.io)
- [دليل التثبيت الأصلي](https://discuss.frappe.io/t/guide-how-to-install-erpnext-v15-on-linux-ubuntu-step-by-step-instructions/111706)

---

## ❓ الأسئلة الشائعة

**س: هل يعمل على نسخ Ubuntu أخرى؟**  
ج: السكريبت معد لـ Ubuntu 22.04 LTS. قد يعمل على إصدارات أحدث لكن قد تحتاج تعديلات.

**س: كم من الوقت يستغرق التثبيت؟**  
ج: عادة 30-60 دقيقة حسب سرعة الإنترنت والسيرفر.

**س: هل يمكنني إيقاف التثبيت؟**  
ج: نعم، اضغط Ctrl+C لكن قد يترك النظام غير كامل.

**س: كيف أحصل على دعم فني؟**  
ج: زر [مجتمع Frappe](https://discuss.frappe.io) أو GitHub Issues.

---

## 📞 الدعم والمساعدة

إذا واجهت مشاكل:

1. **افحص ملف السجل:**
   ```bash
   tail -100 /var/log/erpnext_install_*.log
   ```

2. **تحقق من الحالة:**
   ```bash
   bench status
   ```

3. **أعد تشغيل الخدمات:**
   ```bash
   sudo supervisorctl restart all
   ```

4. **اطلب مساعدة المجتمع:**
   - [Frappe Forum](https://discuss.frappe.io)
   - [GitHub Issues](https://github.com/frappe/erpnext/issues)

---

## ⚖️ الترخيص

هذا السكريبت مبني على [ERPNext](https://github.com/frappe/erpnext) وهو مرخص تحت **GNU GPL v3**.

---

**نسخة: 1.0**  
**آخر تحديث: يونيو 2026**  
**الحالة: ✅ يعمل ويختبر**

---

## 🎉 شكراً لاستخدامك هذا السكريبت!

أتمنى أن يساعدك في تثبيت ERPNext بسهولة.  
لأي اقتراحات أو تحسينات، يرجى فتح issue على GitHub.

**Happy ERPing! 🚀**
