-- Kelaa Market classifieds schema + catalog seed

create table if not exists profiles (
  user_id      text primary key,
  display_name text not null default '',
  phone        text not null default '',
  city         text not null default '',
  role         text not null default 'user',
  created_at   timestamptz not null default now()
);

create table if not exists listings (
  id            serial primary key,
  user_id       text not null,
  title         text not null,
  description   text not null default '',
  price_mad     integer not null,
  condition     text not null,
  category      text not null,
  city          text not null,
  image_url     text not null default '',
  status        text not null default 'pending',
  featured      boolean not null default false,
  seller_name   text not null default '',
  seller_phone  text not null default '',
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists listings_status_idx on listings (status);
create index if not exists listings_user_id_idx on listings (user_id);
create index if not exists listings_category_idx on listings (category);
create index if not exists listings_city_idx on listings (city);

create table if not exists favorites (
  user_id     text not null,
  listing_id  integer not null references listings(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, listing_id)
);

insert into listings
  (user_id, title, description, price_mad, condition, category, city, image_url, status, featured, seller_name, seller_phone)
select * from (values
  (
    'kelaa-seed',
    'iPhone 13 Pro 128 Go — حالة ممتازة',
    'هاتف مستعمل بعناية، بطارية 88%، علبة وشاحن أصلي. بدون خدوش على الشاشة. التسليم في قلعة السراغنة أو مراكش.',
    4200, 'used', 'phones', 'قلعة السراغنة', '/products/phone.jpg', 'approved', true,
    'سوق القلعة', '0661234567'
  ),
  (
    'kelaa-seed',
    'Peugeot 208 2019 — 92 000 كم',
    'سيارة اقتصادية، صيانة منتظمة، تأمين ساري. محرك بنزين، نوافذ كهربائية، بلوتوث. معاينة في مراكش.',
    98000, 'used', 'cars', 'مراكش', '/products/car.jpg', 'approved', true,
    'سوق القلعة', '0662345678'
  ),
  (
    'kelaa-seed',
    'صالون كتان — ثلاث قطع',
    'صالون واسع قماش كتان بيج، مريح ونظيف. مناسب لصالون مغربي عصري. التوصيل متوفر داخل المدينة.',
    3500, 'used', 'furniture', 'الدار البيضاء', '/products/sofa.jpg', 'approved', false,
    'سوق القلعة', '0663456789'
  ),
  (
    'kelaa-seed',
    'ثلاجة بابين ستانلس — 450 لتر',
    'ثلاجة مستعملة أشهر قليلة، تبريد ممتاز، اقتصاد في الكهرباء. السبب: الانتقال لمدينة أخرى.',
    4200, 'used', 'appliances', 'قلعة السراغنة', '/products/fridge.jpg', 'approved', false,
    'سوق القلعة', '0664567890'
  ),
  (
    'kelaa-seed',
    'MacBook Air M1 — 8/256',
    'لابتوب خفيف للعمل والدراسة، بطارية تدوم طويلاً. بدون كلمة سر، حالة شبه جديدة مع الشاحن.',
    6500, 'used', 'electronics', 'الرباط', '/products/laptop.jpg', 'approved', true,
    'سوق القلعة', '0665678901'
  ),
  (
    'kelaa-seed',
    'دراجة مدينة بإطار كريمي',
    'دراجة عملية مع سلة أمامية، فرامل جيدة، مناسبة للتنقل داخل المدينة. تسليم فاس أو قلعة السراغنة.',
    900, 'used', 'sports', 'فاس', '/products/bike.jpg', 'approved', false,
    'سوق القلعة', '0666789012'
  ),
  (
    'kelaa-seed',
    'معطف صوف زيتوني — مقاس M',
    'معطف جديد لم يُلبس، قماش صوف دافئ. قصّة أنيقة للشتاء. البيع بسبب خطأ في المقاس.',
    280, 'new', 'clothes', 'مراكش', '/products/coat.jpg', 'approved', false,
    'سوق القلعة', '0667890123'
  ),
  (
    'kelaa-seed',
    'آلة غسل 7 كغ — باب أمامي',
    'تعمل بشكل ممتاز، برامج متعددة. مستعملة سنتين. التسليم من بني ملال مع إمكانية النقل.',
    2100, 'used', 'appliances', 'بني ملال', '/products/washer.jpg', 'approved', false,
    'سوق القلعة', '0668901234'
  ),
  (
    'kelaa-seed',
    'طاولة طعام خشب جوز مع 4 كراسي',
    'طاولة متينة مع كراسي كتان. مناسبة لعائلة صغيرة. حالة جيدة جداً، بدون كسور.',
    1800, 'used', 'furniture', 'قلعة السراغنة', '/products/table.jpg', 'approved', false,
    'سوق القلعة', '0669012345'
  ),
  (
    'kelaa-seed',
    'تلفاز 55 بوصة 4K',
    'شاشة كبيرة صورة واضحة، منافذ HDMI. الريموت أصلي. مناسب للصالة. التسليم الدار البيضاء.',
    3200, 'used', 'electronics', 'الدار البيضاء', '/products/tv.jpg', 'approved', true,
    'سوق القلعة', '0660123456'
  ),
  (
    'kelaa-seed',
    'هاتف مستعمل للبيع — في انتظار المراجعة',
    'إعلان تجريبي بانتظار موافقة الإدارة. يمكن قبوله أو رفضه من لوحة الأدمن.',
    1500, 'used', 'phones', 'آسفي', '/products/phone.jpg', 'pending', false,
    'بائع جديد', '0670112233'
  ),
  (
    'kelaa-seed',
    'غرفة جلوس كاملة — في انتظار المراجعة',
    'إعلان ثانٍ معلّق ليظهر في قائمة الموافقة لدى الإدارة.',
    2700, 'used', 'furniture', 'الجديدة', '/products/sofa.jpg', 'pending', false,
    'بائع جديد', '0671223344'
  )
) as seed(
  user_id, title, description, price_mad, condition, category, city, image_url, status, featured, seller_name, seller_phone
)
where not exists (select 1 from listings limit 1);
