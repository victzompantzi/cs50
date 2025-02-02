-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Find crime scene description
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = 'Humphrey Street';
-- description: Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery. Littering took place at 16:36. No known witnesses.

-- ? SELECT year, month, day, activity, license_plate FROM bakery_security_logs WHERE hour = 16 AND minute = 36;

-- +------+-------+-----+----------+---------------+
-- | year | month | day | activity | license_plate |
-- +------+-------+-----+----------+---------------+
-- ? 2023 | 7     | 27  | exit     | X4G3938       |
-- +------+-------+-----+----------+---------------+
SELECT year, month, day, hour, minute, activity, license_plate FROM bakery_security_logs WHERE activity = 'exit' AND day=28 AND month=7 AND hour BETWEEN 10 AND 11;
-- +------+-------+-----+------+--------+----------+---------------+
-- | year | month | day | hour | minute | activity | license_plate |
-- +------+-------+-----+------+--------+----------+---------------+
-- | 2023 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
-- ! 2023 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
-- | 2023 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
-- ! 2023 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
-- ! 2023 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
-- | 2023 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
-- | 2023 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
-- ! 2023 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
-- ! 2023 | 7     | 28  | 10   | 35     | exit     | 1106N58       |
-- +------+-------+-----+------+--------+----------+---------------+
SELECT * FROM phone_calls WHERE year = 2023 AND month = 7 AND day = 28 AND duration < 60;
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 221 | (130) 555-0289 | (996) 555-8899 | 2023 | 7     | 28  | 51       |
-- TODO 224 | (499) 555-9472 | (892) 555-8872 | 2023 | 7     | 28  | 36       |
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
-- | 251 | (499) 555-9472 | (717) 555-1342 | 2023 | 7     | 28  | 50       |
-- | 254 | (286) 555-6063 | (676) 555-6554 | 2023 | 7     | 28  | 43       |
-- | 255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7     | 28  | 49       |
-- | 261 | (031) 555-6622 | (910) 555-3251 | 2023 | 7     | 28  | 38       |
-- TODO 279 | (826) 555-1652 | (066) 555-9701 | 2023 | 7     | 28  | 55       |
-- | 281 | (338) 555-6650 | (704) 555-2131 | 2023 | 7     | 28  | 54       |
-- +-----+----------------+----------------+------+-------+-----+----------+
SELECT * FROM atm_transactions WHERE month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw';
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | 246 | 28500762       | 2023 | 7     | 28  | Leggett Street | withdraw         | 48     |
-- | 264 | 28296815       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 266 | 76054385       | 2023 | 7     | 28  | Leggett Street | withdraw         | 60     |
-- | 267 | 49610011       | 2023 | 7     | 28  | Leggett Street | withdraw         | 50     |
-- | 269 | 16153065       | 2023 | 7     | 28  | Leggett Street | withdraw         | 80     |
-- | 288 | 25506511       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 313 | 81061156       | 2023 | 7     | 28  | Leggett Street | withdraw         | 30     |
-- | 336 | 26013199       | 2023 | 7     | 28  | Leggett Street | withdraw         | 35     |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- !!! THIS IS THE MASTER QUERY WITH WHICH I HAVE SOLVED THE EXERCISE
SELECT
  b.account_number, b.person_id, a.atm_location, p.id, p.name, p.phone_number, p.passport_number, p.license_plate, c.month, c.day, c.duration, pas.flight_id, fl.origin_airport_id, fl.destination_airport_id, fl.month, fl.day, fl.hour, fl.minute, ap.abbreviation, ap.city
FROM
  bank_accounts AS b
  JOIN atm_transactions AS a
    ON b.account_number = a.account_number
  JOIN people AS p
    ON p.id = b.person_id
  JOIN phone_calls AS c
    ON c.caller = p.phone_number
  JOIN passengers as pas
    ON pas.passport_number = p.passport_number
  JOIN flights AS fl
    ON pas.flight_id = fl.id
  JOIN airports AS ap
    ON fl.origin_airport_id = ap.id
  JOIN bakery_security_logs AS bk
    ON bk.license_plate = p.license_plate
  WHERE a.month = 7 AND a.day = 28 AND a.atm_location = 'Leggett Street' AND a.transaction_type = 'withdraw' AND c.duration < 60 AND c.day = 28 AND fl.day = 29 AND fl.hour = 8 AND ap.city = 'Fiftyville' AND bk.year = 2023 AND bk.month = 7 AND bk.day = 28 AND bk.activity = 'exit' AND bk.minute BETWEEN 15 AND 25;
-- +----------------+-----------+----------------+--------+--------+----------------+-----------------+---------------+-------+-----+----------+-----------+-------------------+------------------------+-------+-----+------+--------+--------------+------------+
-- | account_number | person_id |  atm_location  |   id   |  name  |  phone_number  | passport_number | license_plate | month | day | duration | flight_id | origin_airport_id | destination_airport_id | month | day | hour | minute | abbreviation |    city    |
-- +----------------+-----------+----------------+--------+--------+----------------+-----------------+---------------+-------+-----+----------+-----------+-------------------+------------------------+-------+-----+------+--------+--------------+------------+
-- | 49610011       | 686048    | Leggett Street | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       | 7     | 28  | 45       | 36        | 8                 | 4                      | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 28296815       | 395717    | Leggett Street | 395717 | Kenny  | (826) 555-1652 | 9878712108      | 30G67EN       | 7     | 28  | 55       | 36        | 8                 | 4                      | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 76054385       | 449774    | Leggett Street | 449774 | Taylor | (286) 555-6063 | 1988161715      | 1106N58       | 7     | 28  | 43       | 36        | 8                 | 4                      | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- +----------------+-----------+----------------+--------+--------+----------------+-----------------+---------------+-------+-----+----------+-----------+-------------------+------------------------+-------+-----+------+--------+--------------+------------+

-- +----------------+-----------+----------------+--------+---------+----------------+-----------------+---------------+
-- | account_number | person_id |  atm_location  |   id   |  name   |  phone_number  | passport_number | license_plate |
-- +----------------+-----------+----------------+--------+---------+----------------+-----------------+---------------+
-- | 49610011       | 686048    | Leggett Street | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
-- | 26013199       | 514354    | Leggett Street | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 16153065       | 458378    | Leggett Street | 458378 | Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       |
-- | 28296815       | 395717    | Leggett Street | 395717 | Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 25506511       | 396669    | Leggett Street | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
-- | 28500762       | 467400    | Leggett Street | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 76054385       | 449774    | Leggett Street | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 81061156       | 438727    | Leggett Street | 438727 | Benista | (338) 555-6650 | 9586786673      | 8X428L0       |
-- +----------------+-----------+----------------+--------+---------+----------------+-----------------+---------------+

-- Check the register of the interviews
select id, name, transcript, day from interviews where year = 2023 AND month = 7 AND day = 28;
-- TODO

SELECT
  pas.flight_id, pas.seat, pas.passport_number, peo.license_plate, peo.name, peo.phone_number, fl.origin_airport_id, fl.destination_airport_id, fl.year, fl.month, fl.day, fl.hour, fl.minute, ap.abbreviation, ap.city
FROM
  passengers AS pas
JOIN
  people AS peo ON pas.passport_number = peo.passport_number
JOIN
  flights AS fl ON pas.flight_id = fl.id
JOIN
  airports AS ap ON fl.origin_airport_id = ap.id
JOIN
  phone_calls as pc ON pc.caller = peo.phone_number
WHERE
  year = 2023
  AND month = 7
  AND day = 29
  AND hour = 8
  AND minute = 20;
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+------------+
-- | flight_id | seat | passport_number | license_plate |  name  |  phone_number  | origin_airport_id | destination_airport_id | year | month | day | hour | minute | abbreviation |    city    |
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+------------+
-- | 36        | 2A   | 7214083635      | M51FA04       | Doris  | (066) 555-9701 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 3B   | 1695452385      | G412CB7       | Sofia  | (130) 555-0289 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 4A   | 5773159633      | 94KL13X       | Bruce  | (367) 555-5533 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 5C   | 1540955065      | 130LD9Z       | Edward | (328) 555-1152 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 6C   | 8294398571      | 0NTHK55       | Kelsey | (499) 555-9472 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 6D   | 1988161715      | 1106N58       | Taylor | (286) 555-6063 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 7A   | 9878712108      | 30G67EN       | Kenny  | (826) 555-1652 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- | 36        | 7B   | 8496433585      | 4328GD8       | Luca   | (389) 555-5198 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+------------+
-- ! According to the matching telephone numbers, the suspects who assisted the robbers are:
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 221 | (130) 555-0289 | (996) 555-8899 | 2023 | 7     | 28  | 51       |
-- TODO 224 | (499) 555-9472 | (892) 555-8872 | 2023 | 7     | 28  | 36       |
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
-- | 251 | (499) 555-9472 | (717) 555-1342 | 2023 | 7     | 28  | 50       |
-- | 254 | (286) 555-6063 | (676) 555-6554 | 2023 | 7     | 28  | 43       |
-- | 255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7     | 28  | 49       |
-- | 261 | (031) 555-6622 | (910) 555-3251 | 2023 | 7     | 28  | 38       |
-- | 279 | (826) 555-1652 | (066) 555-9701 | 2023 | 7     | 28  | 55       |
-- | 281 | (338) 555-6650 | (704) 555-2131 | 2023 | 7     | 28  | 54       |
-- +-----+----------------+----------------+------+-------+-----+----------+
SELECT * FROM people WHERE phone_number = '(499) 555-9472' OR phone_number = '(826) 555-1652';
-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- | 395717 | Kenny  | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- +--------+--------+----------------+-----------------+---------------+
-- ! Acoording with the cars that left the lot:
-- +------+-------+-----+------+--------+----------+---------------+
-- | year | month | day | hour | minute | activity | license_plate |
-- +------+-------+-----+------+--------+----------+---------------+
-- | 2023 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
-- | 2023 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
-- | 2023 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
-- | 2023 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
-- | 2023 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
-- | 2023 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
-- | 2023 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
-- ? 2023 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
-- ! 2023 | 7     | 28  | 10   | 35     | exit     | 1106N58       |
-- +------+-------+-----+------+--------+----------+---------------+
SELECT * FROM people WHERE phone_number = '(499) 555-9472';
-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- ! 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       | <== One of the culprits!
-- +--------+--------+----------------+-----------------+---------------+
SELECT
  pas.flight_id, pas.seat, pas.passport_number, peo.license_plate, peo.name, peo.phone_number, fl.origin_airport_id, fl.destination_airport_id, fl.year, fl.month, fl.day, fl.hour, fl.minute, ap.abbreviation, ap.city
FROM
  passengers AS pas
JOIN
  people AS peo ON pas.passport_number = peo.passport_number
JOIN
  flights AS fl ON pas.flight_id = fl.id
JOIN
  airports AS ap ON fl.origin_airport_id = ap.id
WHERE
  year = 2023
  AND month = 7
  AND day = 29
  AND hour = 8
  AND minute = 20;
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+------------+
-- | flight_id | seat | passport_number | license_plate |  name  |  phone_number  | origin_airport_id | destination_airport_id | year | month | day | hour | minute | abbreviation |    city    |
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+------------+
-- | 36        | 6C   | 8294398571      | 0NTHK55       | Kelsey | (499) 555-9472 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | CSF          | Fiftyville |
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+------------+
SELECT
  pas.flight_id, pas.seat, pas.passport_number, peo.license_plate, peo.name, peo.phone_number, fl.origin_airport_id, fl.destination_airport_id, fl.year, fl.month, fl.day, fl.hour, fl.minute, ap.abbreviation, ap.city
FROM
  passengers AS pas
JOIN
  people AS peo ON pas.passport_number = peo.passport_number
JOIN
  flights AS fl ON pas.flight_id = fl.id
JOIN
  airports AS ap ON fl.destination_airport_id = ap.id
WHERE
  year = 2023
  AND month = 7
  AND day = 29
  AND hour = 8
  AND minute = 20
  AND phone_number = '(499) 555-9472';
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+---------------+
-- | flight_id | seat | passport_number | license_plate |  name  |  phone_number  | origin_airport_id | destination_airport_id | year | month | day | hour | minute | abbreviation |     city      |
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+---------------+
-- | 36        | 6C   | 8294398571      | 0NTHK55       | Kelsey | (499) 555-9472 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | LGA          | New York City |
-- +-----------+------+-----------------+---------------+--------+----------------+-------------------+------------------------+------+-------+-----+------+--------+--------------+---------------+
SELECT
  pas.flight_id, pas.seat, pas.passport_number, peo.license_plate, peo.name, peo.phone_number, fl.origin_airport_id, fl.destination_airport_id, fl.year, fl.month, fl.day, fl.hour, fl.minute, ap.abbreviation, ap.city
FROM
  passengers AS pas
JOIN
  people AS peo ON pas.passport_number = peo.passport_number
JOIN
  flights AS fl ON pas.flight_id = fl.id
JOIN
  airports AS ap ON fl.destination_airport_id = ap.id
WHERE
  year = 2023
  AND month = 7
  AND day = 29
  AND phone_number = '(892) 555-8872';

-- The accomplice is:
SELECT * FROM people WHERE phone_number = '(375) 555-8161';
-- +--------+-------+----------------+-----------------+---------------+
-- |   id   | name  |  phone_number  | passport_number | license_plate |
-- +--------+-------+----------------+-----------------+---------------+
-- | 864400 | Robin | (375) 555-8161 | NULL            | 4V16VO0       |
-- +--------+-------+----------------+-----------------+---------------+
