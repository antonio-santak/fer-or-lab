--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.place (
    place_id bigint NOT NULL,
    address character varying(100) NOT NULL,
    city character varying(50) NOT NULL,
    country_tag character varying(5) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL
);


ALTER TABLE public.place OWNER TO postgres;

--
-- Name: place_place_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.place ALTER COLUMN place_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.place_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: station; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.station (
    station_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    place_id bigint NOT NULL,
    number_of_platforms integer NOT NULL,
    number_of_tracks integer NOT NULL,
    length double precision NOT NULL,
    establishing_date date,
    opening_time time without time zone,
    closing_time time without time zone,
    available boolean NOT NULL,
    train_capacity integer NOT NULL,
    owner character varying(100) NOT NULL,
    owner_contact character varying(100)
);


ALTER TABLE public.station OWNER TO postgres;

--
-- Name: station_station_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.station ALTER COLUMN station_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.station_station_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: train; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train (
    train_id bigint NOT NULL,
    station_id bigint NOT NULL,
    train_type character varying(50) NOT NULL,
    number_of_wagons integer NOT NULL,
    passenger_capacity integer,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL
);


ALTER TABLE public.train OWNER TO postgres;

--
-- Name: train_train_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.train ALTER COLUMN train_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.train_train_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (place_id, address, city, country_tag, latitude, longitude) FROM stdin;
1	Trg Kralja Tomislava 12	Zagreb	HR	45.80466791	15.97880051
2	Kolodvorska ul. 7	Daruvar	HR	45.58888085	17.22636991
3	Prilaz Većeslava Holjevca b.b.	Karlovac	HR	45.48810832	15.54976276
4	Vilima Reinera 3	Karlovac	HR	45.50023672	15.54538848
5	Trg kralja Tomislava 1	Rijeka	HR	45.33022022	14.43041476
6	Ulica Ante Starčevića 3	Zadar	HR	44.10628975	15.24237409
7	Pčelić 60	Pčelić	HR	45.78009825	17.52562698
8	Stjepana Radića 16	Banova Jaruga	HR	45.44589262	16.87642633
9	Kolodvorska ulica 7	Sirač	HR	45.52991504	17.24096959
10	Ul. Matije Gupca 4	Dugo Selo	HR	45.80151386	16.23457049
11	Obala kneza Domagoja 9	Split	HR	43.50474026	16.44296388
12	Trg Republike 1	Sisak	HR	45.49201386	16.37334414
\.


--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.station (station_id, name, place_id, number_of_platforms, number_of_tracks, length, establishing_date, opening_time, closing_time, available, train_capacity, owner, owner_contact) FROM stdin;
1	Zagreb Glavni Kolodvor	1	7	9	800	1892-08-18	00:00:00	23:59:00	t	15	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
2	Željeznički kolodvor Daruvar	2	2	4	250	\N	05:30:00	21:00:00	f	4	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
3	Željeznički kolodvor Karlovac Centar	3	1	2	200	\N	\N	\N	t	2	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
4	Željeznički kolodvor Karlovac	4	3	7	700	1865-06-01	04:00:00	23:30:00	t	8	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
5	Željeznički kolodvor Rijeka	5	3	8	300	\N	04:00:00	23:30:00	t	9	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
6	Željeznički kolodvor Zadar	6	2	5	150	1967-08-18	\N	\N	f	5	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
7	Željeznička stanica Pčelić	7	1	3	50	\N	\N	\N	f	3	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
8	Željeznička stanica Banova Jaruga	8	2	4	250	\N	05:30:00	21:00:00	t	4	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
9	Željeznička stanica Sirač	9	1	3	100	\N	\N	\N	f	3	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
10	Željeznički kolodvor Dugo Selo	10	3	6	300	\N	04:00:00	23:59:00	t	7	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
11	Željeznički kolodvor Split	11	4	6	400	1877-01-06	04:00:00	23:30:00	t	8	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
12	Željeznički kolodvor Sisak	12	2	6	300	1862-10-01	04:00:00	22:00:00	t	6	HŽ Infrastruktura d.o.o.	uprava-hzi@hzinfra.hr
\.


--
-- Data for Name: train; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train (train_id, station_id, train_type, number_of_wagons, passenger_capacity, latitude, longitude) FROM stdin;
1	1	passenger	4	350	45.80448809	15.98019608
2	1	passenger	4	400	45.80480269	15.98491478
3	1	freight	30	\N	45.80432383	15.98439567
4	3	passenger	4	400	45.48834539	15.54976251
5	3	freight	35	\N	45.48895162	15.54846528
6	8	passenger	4	400	45.44652126	16.87493834
7	8	passenger	4	350	45.44455923	16.87774079
8	10	passenger	4	400	45.80106229	16.23117332
9	10	freight	35	\N	45.80153053	16.23873486
10	11	passenger	4	400	43.50341876	16.44391693
11	11	passenger	4	350	43.50411516	16.443471
12	11	freight	10	\N	43.50597057	16.44249374
\.


--
-- Name: place_place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.place_place_id_seq', 1, false);


--
-- Name: station_station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.station_station_id_seq', 1, false);


--
-- Name: train_train_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_train_id_seq', 1, false);


--
-- Name: place pk_place_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT pk_place_id PRIMARY KEY (place_id);


--
-- Name: station pk_station_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT pk_station_id PRIMARY KEY (station_id);


--
-- Name: train pk_train_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train
    ADD CONSTRAINT pk_train_id PRIMARY KEY (train_id);


--
-- Name: fki_fk_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_place_id ON public.station USING btree (place_id);


--
-- Name: fki_fk_station_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_station_id ON public.train USING btree (station_id);


--
-- Name: station fk_place_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT fk_place_id FOREIGN KEY (place_id) REFERENCES public.place(place_id) ON DELETE RESTRICT NOT VALID;


--
-- Name: train fk_station_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train
    ADD CONSTRAINT fk_station_id FOREIGN KEY (station_id) REFERENCES public.station(station_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- PostgreSQL database dump complete
--

