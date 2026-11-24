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

delete from equipment_categories where id = 1;

insert into customers (client_type, phone_number, email_address)
values ('INDIVIDUAL', '999888777', 'studiofilm@gmail.com');

insert into equipment_models (model_name, manufacturer, category_id, daily_rate, deposit, replacement_value, buffer_hours)
values ('Kamera Sony FX6', 'Sony', 3, 500.00, 1000.00, 5000.00, 12);

insert into equipment_models (model_name, manufacturer, category_id, daily_rate, deposit, replacement_value, buffer_hours)
values ('Błędna stawka', 'Sony', 3, 0, 100.00, 500.00, 12);

insert into equipment_models (model_name, manufacturer, category_id, daily_rate, deposit, replacement_value, buffer_hours)
values ('Za niska wartość odtw.', 'Sony', 3, 500.00, 100.00, 400.00, 12);

insert into equipment_models (model_name, manufacturer, category_id, daily_rate, deposit, replacement_value, buffer_hours)
values ('Nieznana kategoria', 'Sony', 999, 500.00, 100.00, 1000.00, 12);

insert into equipment_models_history (model_id, daily_rate, deposit, replacement_value, buffer_hours, valid_period)
values (999, 100.00, 50.00, 500.00, 12, '[2025-01-01 00:00:00+00, )'::tstzrange);

insert into equipment_models_history (model_id, daily_rate, deposit, replacement_value, buffer_hours, valid_period)
values (1, 500.00, 100.00, 400.00, -1, '[2025-01-01 00:00:00+00, )'::tstzrange);

insert into pricing_rules (min_days, max_days, discount_rate)
values (10, 5, 10.00);

insert into pricing_rules (min_days, max_days, discount_rate)
values (1, 3, 60.00);

insert into equipment_units (model_id, serial_number, inventory_code, location, purchase_date, current_status)
values (1, 'SN123456', 'INV-TEST-1', 'Regał A1', '2025-05-01', 'AVAILABLE');

insert into equipment_units (model_id, serial_number, inventory_code, location, purchase_date, current_status)
values (1, 'SN-TEST-1', 'INV-CAM-001', 'Regał A1', '2025-05-01', 'AVAILABLE');

insert into equipment_units (model_id, serial_number, inventory_code, location, purchase_date, current_status)
values (1, 'SN-TEST-2', 'INV-TEST-2', 'Regał A1', '2025-05-01', 'RENTED');

insert into equipment_units_history (unit_id, status, valid_period)
values (999, 'AVAILABLE', '[2025-05-01 00:00:00+00, )'::tstzrange);

insert into equipment_units_history (unit_id, status, valid_period)
values (1, 'BROKEN', '[2025-05-01 00:00:00+00, )'::tstzrange);

insert into kit_definitions (kit_name, discount_rate)
values ('Zestaw filmowy', 10.00);

insert into kit_definitions (kit_name, discount_rate)
values ('Zły rabat zestawu', 75.00);

insert into kit_items (kit_id, model_id, subkit_id, quantity)
values (1, 1, null, 0);

insert into kit_items (kit_id, model_id, subkit_id, quantity)
values (1, null, null, 1);

insert into kit_items (kit_id, model_id, subkit_id, quantity)
values (1, 1, 2, 1);

insert into kit_items (kit_id, model_id, subkit_id, quantity)
values (1, null, 1, 1);
