drop sequence if exists test_sequence;

drop table if exists technician_certifications cascade;
drop table if exists technicians cascade;
drop table if exists business_customers cascade;
drop table if exists individual_customers cascade;
drop table if exists customers cascade;
drop table if exists equipment_categories cascade;


-- sample data
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

-- unit tests
update equipment_categories set parent_id = 1 where id = 1;

insert into customers (client_type, phone_number, email_address)
values ('VIP', '111111111', 'vip.test@gmail.com');

insert into customers (client_type, phone_number, email_address, discount_rate)
values ('INDIVIDUAL', '222222222', 'rabat.test@gmail.com', 55.00);

update business_customers set credit_limit = -100.00 where customer_id = 2;

insert into customers (client_type, phone_number, email_address)
values ('BUSINESS', '333333333', 'firma2.test@gmail.com');

insert into business_customers (customer_id, company_name, nip_number, company_address, credit_limit, deferred_payment_days)
values (3, 'Druga Firma Sp. z o.o.', '1234567890', 'ul. Krótka 5', 1000.00, 7);

insert into technicians (first_name, last_name, email_address, hourly_wage)
values ('Marek', 'Test', 'marek.zero@gmail.com', 0);

insert into technician_certifications (technician_id, category_id, obtaining_certificate_date, certificate_valid_date)
values (2, 1, '2025-06-01', '2025-05-01');

insert into technician_certifications (technician_id, category_id, obtaining_certificate_date, certificate_valid_date)
values (1, 1, '2025-07-01', '2027-07-01');

delete from customers where id = 1;
select * from individual_customers where clients_id = 1;