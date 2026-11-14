--
-- PostgreSQL database dump
--

\restrict Mwa1cKGOGvmx2UZdw8feolxYCxgKV2X875AsW7FSqZYwJDgAoxyG2dCLhbRp0G2

-- Dumped from database version 17.11 (Debian 17.11-0+deb13u1)
-- Dumped by pg_dump version 17.11 (Debian 17.11-0+deb13u1)

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

--
-- Name: demo; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA demo;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: temperature_readings; Type: TABLE; Schema: demo; Owner: -
--

CREATE TABLE demo.temperature_readings (
    tank_id text NOT NULL,
    observed_at timestamp with time zone NOT NULL,
    temperature_c double precision NOT NULL
);


--
-- Name: data_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_sources (
    id bigint NOT NULL,
    source_key text NOT NULL,
    name text NOT NULL,
    source_type text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: data_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.data_sources ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.data_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: measurement_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement_points (
    id bigint NOT NULL,
    source_id bigint NOT NULL,
    point_key text NOT NULL,
    description text,
    data_type text NOT NULL,
    unit text,
    enabled boolean DEFAULT true NOT NULL,
    CONSTRAINT measurement_points_data_type_check CHECK ((data_type = ANY (ARRAY['numeric'::text, 'boolean'::text])))
);


--
-- Name: measurement_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.measurement_points ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.measurement_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: readings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.readings (
    id bigint NOT NULL,
    point_id bigint NOT NULL,
    data_type text NOT NULL,
    observed_at timestamp with time zone NOT NULL,
    received_at timestamp with time zone DEFAULT now() NOT NULL,
    value_numeric double precision,
    value_boolean boolean,
    CONSTRAINT readings_check CHECK ((((data_type = 'numeric'::text) AND (value_numeric IS NOT NULL) AND (value_boolean IS NULL)) OR ((data_type = 'boolean'::text) AND (value_boolean IS NOT NULL) AND (value_numeric IS NULL))))
);


--
-- Name: readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.readings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: temperature_readings temperature_readings_pkey; Type: CONSTRAINT; Schema: demo; Owner: -
--

ALTER TABLE ONLY demo.temperature_readings
    ADD CONSTRAINT temperature_readings_pkey PRIMARY KEY (tank_id, observed_at);


--
-- Name: data_sources data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_pkey PRIMARY KEY (id);


--
-- Name: data_sources data_sources_source_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_source_key_key UNIQUE (source_key);


--
-- Name: measurement_points measurement_points_id_data_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_points
    ADD CONSTRAINT measurement_points_id_data_type_key UNIQUE (id, data_type);


--
-- Name: measurement_points measurement_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_points
    ADD CONSTRAINT measurement_points_pkey PRIMARY KEY (id);


--
-- Name: measurement_points measurement_points_source_id_point_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_points
    ADD CONSTRAINT measurement_points_source_id_point_key_key UNIQUE (source_id, point_key);


--
-- Name: readings readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readings
    ADD CONSTRAINT readings_pkey PRIMARY KEY (id);


--
-- Name: readings readings_point_id_observed_at_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readings
    ADD CONSTRAINT readings_point_id_observed_at_key UNIQUE (point_id, observed_at);


--
-- Name: idx_readings_point_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_readings_point_time ON public.readings USING btree (point_id, observed_at DESC);


--
-- Name: measurement_points measurement_points_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement_points
    ADD CONSTRAINT measurement_points_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.data_sources(id);


--
-- Name: readings readings_point_id_data_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readings
    ADD CONSTRAINT readings_point_id_data_type_fkey FOREIGN KEY (point_id, data_type) REFERENCES public.measurement_points(id, data_type);


--
-- PostgreSQL database dump complete
--

\unrestrict Mwa1cKGOGvmx2UZdw8feolxYCxgKV2X875AsW7FSqZYwJDgAoxyG2dCLhbRp0G2

