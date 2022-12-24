SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public."User" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    firstname text,
    lastname text,
    email text NOT NULL,
    password text NOT NULL,
    type text DEFAULT 'emailpassword'::text NOT NULL,
    username text NOT NULL,
    birthdate timestamp with time zone,
    phone_number text,
    "profilePicture" text
);
ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);
CREATE TRIGGER "set_public_User_updated_at" BEFORE UPDATE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_User_updated_at" ON public."User" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
