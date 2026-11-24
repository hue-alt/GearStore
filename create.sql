create extension if not exists btree_gist;

create sequence if not exists test_sequence
minvalue 100
maxvalue 200
increment 5;

create table if not exists equipment_categories(
    id   int generated always as identity primary key,
    name text not null,
    parent_id int references equipment_categories(id),
    check(parent_id is  null or parent_id <> id)
);

create table if not exists customers(
    id int generated always as identity primary key,
    client_type text not null
    check(client_type = 'BUSINESS' or client_type = 'INDIVIDUAL'),
    phone_number varchar unique not null,
    email_address text unique not null,
    discount_rate numeric(5, 2) not null default 0,
    check(discount_rate >= 0 and discount_rate <= 50),
    blocked_account boolean default false not null,
    register_date timestamptz default current_timestamp not null
);

create table if not exists individual_customers(
    clients_id int primary key references customers(id) on delete cascade,
    first_name text not null,
    middle_name text,
    last_name text not null,
    document_series text unique not null
);

create table if not exists business_customers(
    customer_id int primary key references customers(id) on delete cascade,
    company_name text not null,
    nip_number text unique not null,
    company_address text not null,
    credit_limit numeric(12, 2) not null,
    check(credit_limit >= 0),
    deferred_payment_days smallint default 0 not null,
    check(deferred_payment_days >= 0)
);

create table if not exists technicians(
    id int generated always as identity primary key,
    first_name text not null,
    middle_name text,
    last_name text not null,
    phone_number varchar unique,
    email_address text unique not null,
    hourly_wage numeric(10, 2) not null,
    check(hourly_wage > 0),
    is_active boolean not null default true
);


create table if not exists technician_certifications(
    technician_id int not null references technicians(id) on delete cascade,
    category_id int not null references equipment_categories(id),
    obtaining_certificate_date date not null,
    certificate_valid_date date,
    primary key (technician_id, category_id),
    check (certificate_valid_date is null or obtaining_certificate_date < certificate_valid_date)
);

create table if not exists equipment_models(
    id int generated always as identity primary key,
    model_name text unique not null,
    manufacturer text not null,
    category_id int not null references equipment_categories(id),
    daily_rate numeric(10, 2) not null,
    check(daily_rate > 0),
    deposit numeric(10, 2) not null,
    check(deposit >= 0),
    replacement_value numeric(10, 2) not null,
    check(replacement_value >= daily_rate),
    buffer_hours smallint not null,
    check(buffer_hours >= 0),
    technical_documentation jsonb
);

create table if not exists equipment_models_history(
    id int generated always as identity primary key,
    model_id int not null references equipment_models(id),
    daily_rate numeric(10, 2) not null,
    check(daily_rate > 0),
    deposit numeric(10, 2) not null,
    check(deposit >= 0),
    replacement_value numeric(10, 2) not null,
    check(replacement_value >= daily_rate),
    buffer_hours smallint not null,
    check(buffer_hours >= 0),
    valid_period tstzrange not null
);

create table if not exists pricing_rules(
    id int generated always as identity primary key,
    min_days int not null,
    max_days int not null,
    discount_rate numeric(5, 2) not null,
    check(min_days > 0 and max_days > 0 and min_days <= max_days and discount_rate >= 0 and discount_rate <= 50),
    is_active boolean not null default true
);

create table if not exists equipment_units(
    id int generated always as identity primary key,
    model_id int not null references equipment_models(id),
    serial_number text unique not null,
    inventory_code text unique not null,
    location text not null,
    purchase_date date not null,
    current_status text not null,
    check(current_status = 'AVAILABLE' or current_status = 'DAMAGED' or current_status = 'MAINTENANCE' or current_status = 'RETIRED')
);

create table if not exists equipment_units_history(
    id int generated always as identity primary key,
    unit_id int not null references equipment_units(id),
    status text not null,
    check(status = 'AVAILABLE' or status = 'DAMAGED' or status = 'MAINTENANCE' or status = 'RETIRED'),
    valid_period tstzrange not null
);

create table if not exists kit_definitions(
    id int generated always as identity primary key,
    kit_name text unique not null,
    is_active boolean not null default true,
    discount_rate numeric(5, 2) not null default 0,
    check(discount_rate >= 0 and discount_rate <= 50)
);

create table if not exists kit_items(
    id int generated always as identity primary key,
    kit_id int not null references kit_definitions(id),
    model_id int references equipment_models(id),
    subkit_id int references kit_definitions(id),
    quantity int not null,
    check(quantity > 0),
    check((model_id is not null and subkit_id is null) or (model_id is null and subkit_id is not null and subkit_id <> kit_id))
);

--sample data
insert into equipment_categories (name, parent_id) values
    ('Kamery', null),
    ('Audio', null);

insert into equipment_categories (name, parent_id) values
    ('Kamery filmowe', 1);

insert into customers (client_type, phone_number, email_address, discount_rate) values
    ('INDIVIDUAL', '100200300', 'jan.kowalski@gmail.com', 10.00),
    ('BUSINESS',   '400500600', 'studiofilm@gmail.com',   15.00);

insert into individual_customers (clients_id, first_name, last_name, document_series) values
    (1, 'Jan', 'Kowalski', 'ABC123456');

insert into business_customers (customer_id, company_name, nip_number, company_address, credit_limit, deferred_payment_days) values
    (2, 'Studio Film Sp. z o.o.', '1234567890', 'ul. Filmowa 10, Warszawa', 25000.00, 14);

insert into technicians (first_name, last_name, phone_number, email_address, hourly_wage) values
    ('Anna',  'Nowak',     null,        'anna.nowak@gmail.com',      120.50),
    ('Piotr', 'Zieliński', '700800900', 'piotr.zielinski@gmail.com', 95.00);

insert into technician_certifications (technician_id, category_id, obtaining_certificate_date, certificate_valid_date) values
    (1, 1, '2025-01-10', '2027-01-10'),
    (2, 2, '2025-02-15', null);

insert into equipment_models (model_name, manufacturer, category_id, daily_rate, deposit, replacement_value, buffer_hours, technical_documentation) values
    ('Kamera Sony FX6',  'Sony',     3, 650.00, 3000.00, 28000.00, 24, '{"sensor": "Full-Frame", "mount": "E-mount"}'::jsonb),
    ('Mikrofon Rode NT1','Rode',     2,  60.00,  200.00,  1100.00, 12, '{"type": "condenser", "connector": "XLR"}'::jsonb),
    ('Statyw Sachtler',  'Sachtler', 1, 120.00,    0.00,  4500.00,  0, null);

insert into equipment_models_history (model_id, daily_rate, deposit, replacement_value, buffer_hours, valid_period) values
    (1, 600.00, 2500.00, 28000.00, 24, '[2025-01-01 00:00:00+00, 2025-06-01 00:00:00+00)'::tstzrange),
    (1, 650.00, 3000.00, 28000.00, 24, '[2025-06-01 00:00:00+00, )'::tstzrange),
    (2,  60.00,  200.00,  1100.00, 12, '[2025-01-15 00:00:00+00, )'::tstzrange);

insert into pricing_rules (min_days, max_days, discount_rate, is_active) values
    (1,    3,  0.00, true),
    (4,    6, 10.00, true),
    (7, 9999, 20.00, true),
    (2,    2, 15.00, false);

insert into equipment_units (model_id, serial_number, inventory_code, location, purchase_date, current_status) values
    (1, 'SN123456', 'INV-CAM-001', 'Regał A1', '2025-03-01', 'AVAILABLE'),
    (2, 'SN654321', 'INV-AUD-001', 'Regał B2', '2025-04-15', 'AVAILABLE'),
    (2, 'SN654322', 'INV-AUD-002', 'Serwis',   '2025-04-15', 'MAINTENANCE'),
    (3, 'SN777001', 'INV-STA-001', 'Magazyn',  '2024-01-10', 'DAMAGED'),
    (3, 'SN777002', 'INV-STA-002', 'Archiwum', '2022-05-20', 'RETIRED');

insert into equipment_units_history (unit_id, status, valid_period) values
    (1, 'AVAILABLE',   '[2025-03-01 00:00:00+00, )'::tstzrange),
    (3, 'AVAILABLE',   '[2025-04-15 00:00:00+00, 2025-08-01 10:00:00+00)'::tstzrange),
    (3, 'MAINTENANCE', '[2025-08-01 10:00:00+00, )'::tstzrange),
    (4, 'AVAILABLE',   '[2024-01-10 00:00:00+00, 2025-09-12 16:30:00+00)'::tstzrange),
    (4, 'DAMAGED',     '[2025-09-12 16:30:00+00, )'::tstzrange);

insert into kit_definitions (kit_name, is_active, discount_rate) values
    ('Zestaw filmowy',          true,  15.00),
    ('Zestaw Dokumentalny Pro', true,  20.00),
    ('Zestaw Archiwalny',       false,  0.00);

insert into kit_items (kit_id, model_id, subkit_id, quantity) values
    (1, 1,    null, 1),
    (1, 2,    null, 2),
    (2, null, 1,    1),
    (2, 3,    null, 1);



