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

