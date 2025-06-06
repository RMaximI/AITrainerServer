--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-06-06 13:26:48

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
-- TOC entry 220 (class 1259 OID 41821)
-- Name: friends; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friends (
    user_id integer NOT NULL,
    friend_id integer NOT NULL,
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.friends OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 41838)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer,
    type character varying(50),
    message text,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 41837)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 221
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 224 (class 1259 OID 41854)
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    user_id integer,
    content text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 41853)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO postgres;

--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 223
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 219 (class 1259 OID 41808)
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    user_id integer NOT NULL,
    username character varying(100),
    height_cm integer,
    weight_kg integer,
    age integer,
    gender character varying(10),
    goal text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    level character varying(255)
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 41797)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 41796)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 228 (class 1259 OID 41884)
-- Name: workout_exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workout_exercises (
    id integer NOT NULL,
    name character varying(255),
    video_url text,
    image_url text,
    description text,
    muscle_groups text
);


ALTER TABLE public.workout_exercises OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 41883)
-- Name: workout_exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workout_exercises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workout_exercises_id_seq OWNER TO postgres;

--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 227
-- Name: workout_exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workout_exercises_id_seq OWNED BY public.workout_exercises.id;


--
-- TOC entry 230 (class 1259 OID 41927)
-- Name: workout_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workout_template (
    id integer NOT NULL,
    workout_id bigint,
    exercise_id bigint
);


ALTER TABLE public.workout_template OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 41926)
-- Name: workout_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workout_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workout_template_id_seq OWNER TO postgres;

--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 229
-- Name: workout_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workout_template_id_seq OWNED BY public.workout_template.id;


--
-- TOC entry 226 (class 1259 OID 41869)
-- Name: workouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workouts (
    id integer NOT NULL,
    user_id integer,
    title character varying(255),
    description text,
    date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.workouts OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 41868)
-- Name: workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workouts_id_seq OWNER TO postgres;

--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 225
-- Name: workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workouts_id_seq OWNED BY public.workouts.id;


--
-- TOC entry 4779 (class 2604 OID 41841)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 4782 (class 2604 OID 41857)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 41800)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 41887)
-- Name: workout_exercises id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_exercises ALTER COLUMN id SET DEFAULT nextval('public.workout_exercises_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 41930)
-- Name: workout_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_template ALTER COLUMN id SET DEFAULT nextval('public.workout_template_id_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 41872)
-- Name: workouts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts ALTER COLUMN id SET DEFAULT nextval('public.workouts_id_seq'::regclass);


--
-- TOC entry 4962 (class 0 OID 41821)
-- Dependencies: 220
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.friends (user_id, friend_id, status, created_at) VALUES (1, 2, 'accepted', '2025-06-02 12:22:55.30152');
INSERT INTO public.friends (user_id, friend_id, status, created_at) VALUES (2, 1, 'accepted', '2025-06-02 12:22:55.30152');


--
-- TOC entry 4964 (class 0 OID 41838)
-- Dependencies: 222
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.notifications (id, user_id, type, message, is_read, created_at) VALUES (1, 1, 'friend_request', 'User Two sent you a friend request.', false, '2025-06-02 12:22:55.30152');
INSERT INTO public.notifications (id, user_id, type, message, is_read, created_at) VALUES (2, 2, 'workout_invite', 'User One invited you to a workout.', false, '2025-06-02 12:22:55.30152');


--
-- TOC entry 4966 (class 0 OID 41854)
-- Dependencies: 224
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posts (id, user_id, content, created_at) VALUES (1, 1, 'Completed an intense leg day workout!', '2025-06-02 12:22:55.30152');
INSERT INTO public.posts (id, user_id, content, created_at) VALUES (2, 2, 'Started my fitness journey today!', '2025-06-02 12:22:55.30152');


--
-- TOC entry 4961 (class 0 OID 41808)
-- Dependencies: 219
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.profiles (user_id, username, height_cm, weight_kg, age, gender, goal, updated_at, level) VALUES (1, 'User One', 175, 70, 25, 'male', 'Build muscle', '2025-06-02 12:22:55.30152', NULL);
INSERT INTO public.profiles (user_id, username, height_cm, weight_kg, age, gender, goal, updated_at, level) VALUES (2, 'User Two', 160, 55, 28, 'female', 'Lose weight', '2025-06-02 12:22:55.30152', NULL);
INSERT INTO public.profiles (user_id, username, height_cm, weight_kg, age, gender, goal, updated_at, level) VALUES (3, 'JohnDoe', 180, 75, 25, 'male', 'lose weight', '2025-06-05 14:27:14.92494', 'intermediate');
INSERT INTO public.profiles (user_id, username, height_cm, weight_kg, age, gender, goal, updated_at, level) VALUES (13, 'bdhfh', 151, 171, 53, 'male', 'improve strength', '2025-06-06 01:38:42.921053', 'advanced');
INSERT INTO public.profiles (user_id, username, height_cm, weight_kg, age, gender, goal, updated_at, level) VALUES (14, 'maxim', 151, 171, 87, 'male', 'improve strength', '2025-06-06 01:53:53.51391', 'advanced');


--
-- TOC entry 4960 (class 0 OID 41797)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, email, password_hash, created_at) VALUES (1, 'user1@example.com', 'hashed_password_1', '2025-06-02 12:22:55.30152');
INSERT INTO public.users (id, email, password_hash, created_at) VALUES (2, 'user2@example.com', 'hashed_password_2', '2025-06-02 12:22:55.30152');
INSERT INTO public.users (id, email, password_hash, created_at) VALUES (3, 'example@example.com', 'hashed_password', '2025-06-05 14:27:14.92494');
INSERT INTO public.users (id, email, password_hash, created_at) VALUES (13, 'mr.rusakov.maxim@gmail.com', '1234567kiL$', '2025-06-06 01:38:42.921053');
INSERT INTO public.users (id, email, password_hash, created_at) VALUES (14, 'mr.rusakov.maxim@gmail.c', '1234567kiL$', '2025-06-06 01:53:53.51391');


--
-- TOC entry 4970 (class 0 OID 41884)
-- Dependencies: 228
-- Data for Name: workout_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (4, 'Приседания', 'https://rutube.ru/video/a5813bdc1ee9ee795dd55dca1114e40f/', 'https://images.pexels.com/photos/176782/pexels-photo-176782.jpeg?cs=srgb&dl=pexels-keiji-yoshiki-31563-176782.jpg&fm=jpg', 'Приседания – базовое упражнение, при котором человек опускается в присед и затем возвращается в положение стоя. Упражнение эффективно развивает мышцы ног и ягодицы, особенно квадрицепсы, а также укрепляет мышцы кора и спины.', 'Ноги, ягодицы, мышцы кора');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (9, 'Боковая планка', 'https://rutube.ru/video/1a2d40099185fabd860e9a56a5ce6b82/', 'https://images.pexels.com/photos/791764/pexels-photo-791764.jpeg?cs=srgb&dl=pexels-victorfreitas-791764.jpg&fm=jpg', 'Боковая планка – вариант планки, при котором тело удерживается боком на одном предплечье и боковой поверхности стопы. В таком положении подтягивается корпус, а нагрузка приходится на косые мышцы живота и бока. Упражнение помогает развивать боковые мышцы корпуса и повышает общую устойчивость.', 'Кор, плечи');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (10, 'Скручивания', 'https://rutube.ru/video/dae68aedc3f28a1d9fd2c3a7e17b7b2b/', 'https://upload.wikimedia.org/wikipedia/commons/3/34/1st_Lt._Andrew_DAmelio_Does_Sit-Ups_(7637568442).jpg', 'Скручивания – изолирующее упражнение для верхней части живота. Лёжа на спине, согните колени, руки за головой или на груди, затем поднимайте плечи к коленям, напрягая пресс, и медленно опускайтесь. Упражнение целенаправленно развивает прямую мышцу живота и помогает формировать рельефный пресс.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (11, 'Бёрпи', 'https://rutube.ru/video/ab8c271c71847d19f50f251e0dc4b208/', 'https://images.pexels.com/photos/6516225/pexels-photo-6516225.jpeg?cs=srgb&dl=pexels-polina-tankilevitch-6516225.jpg&fm=jpg', 'Бёрпи – высокоинтенсивное упражнение, сочетающее прыжок и отжимание. Начинается из положения стоя, затем выполняется прыжок в планку и отжимание, после чего происходит обратный прыжок. Бёрпи задействуют все основные группы мышц: ноги, руки, спину и пресс, а также укрепляют сердечно-сосудистую систему, повышая общую выносливость.', 'Все группы (кардио)');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (12, 'Мостик ягодичный', 'https://rutube.ru/video/0f43ec59f40b483aa8def8fa671e8de3/', 'https://images.pexels.com/photos/1300526/pexels-photo-1300526.jpeg?cs=srgb&dl=pexels-mastercowley-1300526.jpg&fm=jpg', 'Ягодичный мостик – изолирующее упражнение для ягодиц. Лёжа на спине, согните ноги в коленях и поставьте стопы на пол. Поднимайте таз вверх, сжимая ягодицы, до образования прямой линии от плеч до колен, затем опускайте. Мостик эффективно нагружает большие ягодичные мышцы и мышцы задней поверхности бедра.', 'Ягодицы, задняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (13, 'Отжимания от скамьи', 'https://rutube.ru/video/44a7607edef25832a21b0d454c500178/', 'https://images.pexels.com/photos/7298411/pexels-photo-7298411.jpeg?cs=srgb&dl=pexels-kindelmedia-7298411.jpg&fm=jpg', 'Обратные отжимания от скамьи – упражнение на трицепсы. Сидя на краю скамьи, разместите руки за спиной на её краю и выпрямите ноги перед собой. Опускайте корпус вниз, сгибая локти, затем выпрямляйте руки, поднимая тело обратно. Основная нагрузка приходится на трицепсы и задние дельты.', 'Трицепс, плечи');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (14, 'Тяга гантели в наклоне', 'https://rutube.ru/video/aaa1760b07001db1a687c822b9aca596/', 'https://images.pexels.com/photos/30246184/pexels-photo-30246184.jpeg?cs=srgb&dl=pexels-andrea-musto-135941147-30246184.jpg&fm=jpg', 'Тяга гантели в наклоне – упражнение для мышц спины. С наклонённым корпусом и прямой спиной тяните гантель к поясу одной рукой, разводя лопатки. Это укрепляет широчайшие мышцы спины, ромбовидные мышцы и задействует бицепс.', 'Спина, бицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (15, 'Жим штанги лёжа', 'https://rutube.ru/video/e05a4071d4f8718af6838ebc62cfd4d4/', 'https://images.pexels.com/photos/5496589/pexels-photo-5496589.jpeg?cs=srgb&dl=pexels-sinileunen-5496589.jpg&fm=jpg', 'Жим штанги лёжа – классическое упражнение для развития груди и рук. Лёжа на скамье, опускайте штангу к груди, затем выжимайте её вверх, разгибая локти. На большую часть нагрузки работают большая грудная мышца, трицепсы и передние дельты.', 'Грудь, трицепс, плечи');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (16, 'Жим гантелей сидя', 'https://rutube.ru/video/66fce5e3a61bb7f42f17d16ea9cd2d68/', 'https://images.pexels.com/photos/2475875/pexels-photo-2475875.jpeg?cs=srgb&dl=pexels-823sl-2475875.jpg&fm=jpg', 'Жим гантелей сидя – упражнение для плеч. Сидя на скамье, держите гантели у плеч. Поднимайте гантели вверх, распрямляя руки, затем опускайте под контролем. Оно эффективно прорабатывает передние и средние дельтовидные мышцы, а также трапеции.', 'Плечи, трапеции');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (17, 'Отжимания на брусьях', 'https://rutube.ru/video/20700c6dd055f49fe59285c8f75a0028/', 'https://images.pexels.com/photos/7289236/pexels-photo-7289236.jpeg?cs=srgb&dl=pexels-alesiakozik-7289236.jpg&fm=jpg', 'Отжимания на брусьях – упражнение для груди и трицепсов. Опираясь на брусья прямым телом, опускайтесь вниз за счёт сгибания рук, затем выпрямляйте локти, поднимая корпус. Упражнение нагружает большую грудную мышцу, трицепсы и передние дельты.', 'Грудь, трицепс, плечи');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (18, 'Прыжок из приседа', 'https://rutube.ru/video/e2a32f75b120f3cfbd4f51e9e5ea65df/', 'https://images.pexels.com/photos/1300526/pexels-photo-1300526.jpeg?cs=srgb&dl=pexels-mastercowley-1300526.jpg&fm=jpg', 'Прыжок из приседа – взрывное упражнение на ноги. Из полного приседа взрывообразно выпрыгните вверх и приземлитесь обратно в присед. Это повышает силу и выносливость ног, в основном нагружая квадрицепсы, ягодицы и икроножные мышцы.', 'Ноги, ягодицы, икры');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (19, 'Становая тяга', 'https://rutube.ru/video/dbe03135d548c31363088d7392c20ed4/', 'https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg?cs=srgb&dl=pexels-willpicturethis-1954524.jpg&fm=jpg', 'Становая тяга – базовое силовое упражнение со штангой. Из позиции наклона с прямой спиной штангу поднимают с пола до положения стоя за счёт разгибания бедер и спины. Становая тяга сильно нагружает ягодичные мышцы, подколенные сухожилия, поясницу и широчайшие мышцы спины.', 'Спина, ягодицы, задняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (20, 'Подъем на носки стоя', 'https://rutube.ru/video/25c332d28bca79ec85ccef4b96f13016/', 'https://images.pexels.com/photos/7689285/pexels-photo-7689285.jpeg?cs=srgb&dl=pexels-cottonbro-7689285.jpg&fm=jpg', 'Подъем на носки стоя – упражнение для икроножных мышц. Стоя прямо, поднимайтесь на носки максимально высоко, затем медленно опускайтесь. Упражнение укрепляет икроножные мышцы и повышает их выносливость.', 'Икры');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (21, 'Махи гантелями в стороны', 'https://rutube.ru/video/04e281f614c7936815a50c00b4c22082/', 'https://images.pexels.com/photos/6389869/pexels-photo-6389869.jpeg?cs=srgb&dl=pexels-tima-miroshnichenko-6389869.jpg&fm=jpg', 'Махи гантелями в стороны – упражнение для плеч. Стоя, разводите гантели в стороны до уровня плеч, удерживая небольшой угол в локтях. На вдохе поднимайте гантели, на выдохе опускайте. Это активно нагружает средние дельты и верхние трапеции.', 'Плечи');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (22, 'Сгибание рук на бицепс', 'https://rutube.ru/video/6e7b5eacb456f6769a27e4338390af14/', 'https://upload.wikimedia.org/wikipedia/commons/a/ad/Biceps_curl.jpg', 'Сгибание рук на бицепс – классическое упражнение для двуглавых мышц плеча. Стоя прямо с гантелями в руках, на вдохе сгибайте локти, поднимая гантели к плечам, на выдохе опускайте. Упражнение максимально нагружает бицепсы и задействует предплечья.', 'Бицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (54, 'Тяга штанги к подбородку', 'https://rutube.ru/video/tyaga-shtangi-k-podborodku/', 'https://upload.wikimedia.org/wikipedia/commons/8/82/Barbell_Upright_Row.png', 'Тяга штанги к подбородку – из положения стоя со штангой в опущенных руках на выдохе тянут штангу по туловищу вверх до линии подбородка, локти разводят в стороны. Упражнение нагружает дельтовидные мышцы и трапеции.', 'Плечи, трапеции');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (55, 'Тяга гантелей к поясу в наклоне', 'https://rutube.ru/video/tyaga-ganteley-k-poyasu-v-naklone/', 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Bent_Over_Dumbbell_Row.png', 'Тяга гантелей к поясу в наклоне – с наклоном корпуса и прямой спиной тянут гантели к поясу поочерёдно или сразу двумя руками, сводя лопатки. Эффективно прорабатывает широчайшие мышцы спины, ромбовидные мышцы и бицепсы.', 'Спина, бицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (57, 'Подтягивания широким хватом', 'https://rutube.ru/video/podtyagivaniya-shirokim-khvatom/', 'https://upload.wikimedia.org/wikipedia/commons/0/0b/Pull-up.png', 'Подтягивания широким хватом – хват рук шире плеч, ладони от себя. Подтягиваются до касания перекладины подбородком. Максимально нагружает верхнюю часть спины, трапеции и задние дельты.', 'Спина');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (58, 'Тяга блока к поясу сидя', 'https://rutube.ru/video/tyaga-bloka-k-poyasu-sidya/', 'https://upload.wikimedia.org/wikipedia/commons/2/28/Seated_Cable_Row.png', 'Тяга нижнего блока к поясу сидя – сидя на тренажёре, зацепив рукоять, тянут её к поясу, сводя лопатки. Упражнение развивает широчайшие мышцы спины, ромбовидные и бицепсы.', 'Спина, бицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (59, 'Тяга Т‑штанги', 'https://rutube.ru/video/tyaga-t-shtangi/', 'https://upload.wikimedia.org/wikipedia/commons/7/70/T-bar_row.png', 'Тяга Т-штанги – опираясь одной стороной корпуса на скамью или специальный упор, тянут рукоять Т‑грифа (штанга ставится в угол) к себе. Отлично нагружает середину спины и широчайшие.', 'Спина');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (60, 'Пуловер с гантелей лёжа', 'https://rutube.ru/video/pulover-s-ganteley-lezha/', 'https://upload.wikimedia.org/wikipedia/commons/2/26/Dumbbell_Pullover.png', 'Пуловер с гантелей лёжа – лёжа поперёк скамьи (плечи лежат, ноги на полу), обеими руками удерживают гантель над грудью. На вдохе опускают за голову с лёгким сгибом в локтях, затем возвращаются. Прорабатывает широчайшие и грудные мышцы.', 'Спина, грудь');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (61, 'Разведение гантелей лёжа', 'https://rutube.ru/video/razvedenie-ganteley-lezha/', 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Dumbbell_Fly.png', 'Разведение гантелей лёжа – лёжа на скамье, руки с гантелями слегка согнуты в локтях. На вдохе разводят руки в стороны, на выдохе сводят над грудью. Изолирует грудные мышцы.', 'Грудь');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (62, 'Плие‑присед с гантелей', 'https://rutube.ru/video/plie-prised-s-ganteley/', 'https://upload.wikimedia.org/wikipedia/commons/1/10/Sumo_squat.jpg', 'Плие‑присед с гантелей – присед «сумо» с широкой постановкой ног и гантелью перед собой. Носки развёрнуты наружу. При приседе колени следуют по той же траектории, что и носки. Усиливает нагрузку на приводящие мышцы бедра и внутреннюю поверхность ягодиц.', 'Ноги, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (63, 'Болгарские сплит‑приседы', 'https://rutube.ru/video/bolgarskie-split-prisedy/', 'https://upload.wikimedia.org/wikipedia/commons/5/53/Bulgarian_Split_Squat.png', 'Болгарские сплит‑приседы – задняя нога опирается на скамью, передняя стоит вперёд. Опускаются на передней ноге, колено не выходит за носок, затем возвращаются. Упражнение прорабатывает квадрицепсы и ягодичные мышцы каждой ноги отдельно.', 'Ноги, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (5, 'Отжимания от пола', 'https://rutube.ru/video/d8c0185642906970601512f09cdb1661/', 'https://images.pexels.com/photos/371049/pexels-photo-371049.jpeg?cs=srgb&dl=pexels-823sl-371049.jpg&fm=jpg', 'Отжимания – базовое упражнение для развития мышц верхней части тела. Исходное положение – лёжа лицом вниз, руки упираются в пол. При выполнении отжиманий человек поднимает корпус за счёт выпрямления рук, а затем опускается обратно, контролируя движение. Это упражнение прорабатывает грудные мышцы, трицепсы и передние дельтовидные мышцы.', 'Грудь, трицепс, плечи');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (6, 'Подтягивания', 'https://rutube.ru/video/d8400c270618cde9f171b844f720c187/', 'https://images.pexels.com/photos/3837788/pexels-photo-3837788.jpeg?cs=srgb&dl=pexels-olly-3837788.jpg&fm=jpg', 'Подтягивания – упражнение для развития силы верхней части тела, при котором человек висит на перекладине и подтягивает корпус, сгибая руки. Движение выполняется до тех пор, пока подбородок или грудь не достигнут уровня перекладины. Подтягивания эффективно нагружают широчайшие мышцы спины, а также бицепсы и предплечья.', 'Спина, бицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (7, 'Выпады', 'https://rutube.ru/video/f26d33c1862cea645a850703007e7eae/', 'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg?cs=srgb&dl=pexels-victorfreitas-841130.jpg&fm=jpg', 'Выпады – силовое упражнение для ног. Выполняется шагом вперёд (или назад) с последующим сгибанием коленного сустава и опусканием таза. Во время выпадов активно работают квадрицепсы и ягодичные мышцы, также задействуются подколенные сухожилия. Правильная техника включает контроль колена впереди носка и прямую спину.', 'Ноги, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (8, 'Планка', 'https://rutube.ru/video/7569bcaba5a5930670569af76c7267d6/', 'https://upload.wikimedia.org/wikipedia/commons/6/65/John_J._Quinlan_Gym_Training_on_October_19,_2019.jpg', 'Планка – статическое упражнение на мышцы кора. Исходное положение – упор лёжа на предплечьях и носках, тело держится прямым, как доска. Цель – удерживать ровную линию тела как можно дольше. Планка укрепляет прямую и косые мышцы живота, а также мышцы поясницы и плеч для стабилизации тела.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (23, 'Французский жим лежа', 'https://rutube.ru/video/caa4e5640fbc3df27b0e719c4f9576de/', 'https://upload.wikimedia.org/wikipedia/commons/e/ed/Triceps_extension.svg', 'Французский жим лёжа – упражнение для трицепсов. Лёжа на скамье, возьмите узкий хват штанги. На вдохе опускайте штангу к лбу, сгибая локти, на выдохе выпрямляйте руки. Это изолированно нагружает длинную головку трицепса.', 'Трицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (24, 'Русский твист', 'https://rutube.ru/video/d98eb2202f13903d19a285461e79dd58/', 'https://upload.wikimedia.org/wikipedia/commons/4/45/Russian_twist_exercise_with_dumbbell.jpg', 'Русский твист – упражнение на косые мышцы живота. Сядьте на пол, отклонитесь назад, ноги согните или приподнимите, руки с гантелью перед собой. Скручивайте корпус поочередно вправо и влево, максимально задействуя пресс.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (25, 'Велосипед', 'https://rutube.ru/video/d2af00caf57d4e4632e01ebd7e61bae4/', 'https://upload.wikimedia.org/wikipedia/commons/7/7b/Bicycle_crunch_2_by_Jonathan_P.jpg', 'Упражнение «велосипед» выполняется лежа на спине: руки за головой, поднятые ноги и поочерёдное подтягивание локтя к противоположному колену. «Велосипед» нагружает прямую и косые мышцы живота, эффективно укрепляя пресс.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (26, 'Прыжки звездой', 'https://rutube.ru/video/53e16a3d4d049789551fead56f47fbfc/', 'https://upload.wikimedia.org/wikipedia/commons/1/1d/Jumping_Jacks.jpg', 'Прыжки звезда – кардио-упражнение. Из положения стоя сжимайте и разжимайте ноги в прыжке, одновременно разводя и опуская руки. При каждом прыжке ноги разводятся в стороны, а руки поднимаются над головой. Упражнение задействует ноги, ягодицы и плечевой пояс, улучшая выносливость.', 'Ноги, ягодицы, кор (кардио)');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (27, 'Выпады назад', 'https://rutube.ru/video/e567204d2a99822c8b21cbb05dd31595/', 'https://upload.wikimedia.org/wikipedia/commons/9/91/Reverse_Lunge.jpg', 'Обратные выпады – вариант выпадов, когда шаг делается назад. Делайте шаг назад и опускайтесь так, чтобы заднее колено почти касалось пола. Вернитесь в исходное положение. Упражнение прорабатывает квадрицепсы и ягодицы, а также растягивает подколенные сухожилия.', 'Ноги, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (28, 'Плие-присед', 'https://rutube.ru/video/6b201384ed4d2b8d47e11cdf51e888d0/', 'https://upload.wikimedia.org/wikipedia/commons/1/10/Sumo_squat.jpg', 'Сумо-присед (плие) – присед с широко расставленными ногами и носками наружу. Опускаясь, старайтесь держать спину прямой. Это упражнение хорошо растягивает и укрепляет внутреннюю поверхность бедра (приводящие мышцы), а также нагружает квадрицепсы и ягодицы.', 'Ноги, ягодицы, внутренняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (29, 'Гиперэкстензия', 'https://rutube.ru/video/10c264fa530c1b866db10a31194733eb/', 'https://upload.wikimedia.org/wikipedia/commons/9/9d/Hyper_bench.jpg', 'Гиперэкстензия – упражнение для поясницы. Обычно выполняется на специальной скамье: лежа лицом вниз, зафиксировав ноги, поднимайте корпус вверх, разгибая спину, затем медленно опускайтесь. Упражнение укрепляет мышцы поясницы (разгибатели спины), ягодичные мышцы и заднюю поверхность бедра.', 'Спина, ягодицы, задняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (30, 'Махи гирей', 'https://rutube.ru/video/bc538f55e9210f4abb3118f5f3604ca1/', 'https://upload.wikimedia.org/wikipedia/commons/c/ce/KettlebellSwing.png', 'Махи гирей – упражнение для ног и спины. Из позиции приседа с гирей между ног резко выпрыгивайте вперёд, распрямляя бедра и выпрямляя спину, а затем контролируемо опускайтесь. Движение похоже на качание, хорошо нагружает ягодицы, мышцы задней поверхности бедра и спину.', 'Спина, ягодицы, задняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (31, 'Обратная планка', 'https://rutube.ru/video/6410500d5750b8382af8b3ebf53983c6/', 'https://upload.wikimedia.org/wikipedia/commons/1/11/Reverse_Plank_Position.jpg', 'Обратная планка – статическое упражнение на мышцы кора и спины. Лёжа на спине, опирайтесь на ладони и пятки, поднимая таз вверх, удерживая тело прямым. Обратная планка укрепляет ягодицы, заднюю поверхность бедра и мышцы спины, а также задействует плечи.', 'Кор, спина, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (32, 'Высокие колени', 'https://rutube.ru/video/1bc94d23ee496c2f619f9b259cbdbd6f/', 'https://upload.wikimedia.org/wikipedia/commons/a/a3/High_knees.jpg', 'Бег на месте с высоким подниманием колен – кардио-упражнение. Бегите на месте, поднимая колени максимально высоко к груди. Это движение повышает пульс, прорабатывает квадрицепсы и ягодицы, а также задействует мышцы корпуса для стабилизации.', 'Ноги, ягодицы, кор (кардио)');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (33, 'Бег на месте', 'https://rutube.ru/video/0847257ea710d121e513e8c00a7ab62c/', 'https://upload.wikimedia.org/wikipedia/commons/a/a5/Running_in_place.jpg', 'Бег на месте – базовое кардио-упражнение. Имитируйте бег без перемещения: слегка поднимайте колени и активно двигайте руками. Упражнение увеличивает пульс, тренирует мышцы ног и улучшает выносливость.', 'Ноги, ягодицы, икры, кор (кардио)');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (34, 'Тяга верхнего блока', 'https://rutube.ru/video/4be155b8f2b04e3d861786625ab0f021/', 'https://upload.wikimedia.org/wikipedia/commons/4/4b/Lat_Pulldown.jpg', 'Тяга верхнего блока – упражнение для спины на тренажёре. Сидя на скамье, возьмитесь за перекладину широким хватом, затем тяните её вниз к груди, сводя лопатки. Это движение тренирует широчайшие мышцы спины, задействует бицепсы и мышцы предплечья.', 'Спина, бицепс');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (35, 'Обратные скручивания', 'https://rutube.ru/video/65d5e96275dc95618b18ffe451def233/', 'https://upload.wikimedia.org/wikipedia/commons/b/bb/Reverse_crunch.png', 'Обратные скручивания – упражнение на нижнюю часть пресса. Лёжа на спине, подтягивайте согнутые в коленях ноги к груди, скручивая таз. Медленно опускайте ноги вниз, не касаясь пола. Упражнение эффективно укрепляет нижнюю часть прямой мышцы живота.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (36, 'Боковые выпады', 'https://rutube.ru/video/e8a0b38183193153ef6d1b3dbeab2666/', 'https://upload.wikimedia.org/wikipedia/commons/8/86/Side_Lunge.jpg', 'Боковые выпады – упражнение для ног и внутренней поверхности бедра. Из исходного положения шагните одной ногой в сторону и опуститесь вниз, сгибая колено, при этом вторая нога остаётся прямой. Затем вернитесь. Это упражнение укрепляет квадрицепсы и приводящие мышцы бедра.', 'Ноги, внутренняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (37, 'Супермен', 'https://rutube.ru/video/c1607f58ec8dcf954993593382fdf867/', 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Superman_exercise,_isometric_back_hyperextension.png', 'Супермен – статическое упражнение для мышц спины. Лягте на живот, вытяните руки вперёд или разместите их под головой. Поднимите одновременно руки и ноги над полом и удерживайте несколько секунд. Оно укрепляет мышцы поясницы, ягодицы и заднюю дельтовидную мышцу.', 'Спина, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (38, 'Лодочка', 'https://rutube.ru/video/fd6d3d6377ccc7d6c562d24456cf9ed1/', 'https://upload.wikimedia.org/wikipedia/commons/9/9e/Boat_pose.jpg', 'Упражнение лодочка – вариант гимнастического упражнения. Лягте на живот и одновременно поднимите корпус и ноги вверх, удерживая их прямыми, образуя форму лодки. Упражнение развивает мышцы спины и ягодиц.', 'Спина, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (39, 'Планка с подъемом ноги', 'https://rutube.ru/video/febb16fc8b07de74b09f32a06eaf0609/', 'https://upload.wikimedia.org/wikipedia/commons/1/1b/Plank_one_leg.png', 'Планка с подъемом ноги – усложнённый вариант классической планки. В положении упор лёжа поочерёдно поднимайте прямые ноги вверх, удерживая тело прямым. Кроме мышц кора и пресса активно включаются ягодицы и задняя поверхность бедра.', 'Кор, ягодицы');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (40, 'Подъем корпуса', 'https://rutube.ru/video/2c950c77c8261e515282487dd0a4f550/', 'https://upload.wikimedia.org/wikipedia/commons/4/45/Sit-up_%28exercise%29.png', 'Подъем корпуса (сидя) – классическое упражнение на пресс. Лягте на спину, согните ноги в коленях, руки за головой. На выдохе поднимайте корпус к коленям, напрягая мышцы живота, затем медленно опускайтесь. Основная цель – укрепление прямой мышцы живота.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (41, 'Альпинист', 'https://rutube.ru/video/d0157da77a011a70d23d91c15f7c31bc/', 'https://upload.wikimedia.org/wikipedia/commons/7/78/Mountain_climbers.png', 'Упражнение «альпинист» — динамическое кардио-упражнение. В позиции упор лёжа поочерёдно подтягивайте колени к груди, имитируя бег. Упражнение тренирует пресс, плечи и ноги, а также развивает выносливость.', 'Кор, плечи, ноги (кардио)');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (42, 'Подъем на коробку', 'https://rutube.ru/video/b5a611d793cc3b07674d53ddfcc35777/', 'https://upload.wikimedia.org/wikipedia/commons/b/bd/Step-ups.jpg', 'Подъем на коробку (степ) – упражнение для ног. С одной ноги вставайте на платформу и полностью выпрямляйте её, поднимая всё тело, затем опускайтесь обратно. Оно нагружает квадрицепсы, ягодицы и икроножные мышцы.', 'Ноги, ягодицы, икры');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (43, 'Подъем ног лежа', 'https://rutube.ru/video/1d0bf80475d1d2f4b410e2768f3aa028/', 'https://upload.wikimedia.org/wikipedia/commons/c/c3/Straight_Leg_Raise_Exercise.jpeg', 'Подъем ног лежа – упражнение для нижней части пресса. Лягте на спину, ноги прямые, поднимайте их вертикально вверх и медленно опускайте. Важно держать поясницу прижатой к полу. Упражнение интенсивно вовлекает нижнюю часть прямой мышцы живота.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (44, 'Наклоны корпуса в стороны', 'https://rutube.ru/video/b1fdca24c487c7026a8f4a134b6de016/', 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Side_bend.jpg', 'Наклоны корпуса в стороны – упражнение для косых мышц живота. Стоя прямо, наклоняйте туловище влево и вправо, стараясь дотронуться рукой до колена. Упражнение укрепляет боковые мышцы пресса и мышцы кора.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (45, 'Колено к локтю стоя', 'https://rutube.ru/video/99cb63f0fe2c46743d87f413354de811/', 'https://upload.wikimedia.org/wikipedia/commons/6/66/Knee_Up_to_Elbow.jpg', 'Наклоны локтем к колену стоя – упражнение на пресс и корпус. Стоя прямо, поочередно поднимайте колено к противоположному локтю, поворачивая корпус. Укрепляет косые мышцы живота и прямую мышцу живота.', 'Кор');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (46, 'Приседания с гантелями', 'https://rutube.ru/video/prisedaniya-s-gantelyami/', 'https://upload.wikimedia.org/wikipedia/commons/9/9e/Dumbbell_Squat.png', 'Приседания с гантелями – вариант классических приседаний, при котором в руках держат по одной гантели у плеч. При выполнении приседа спину держат прямо, колени не выходят за носки. Упражнение прорабатывает квадрицепсы, ягодицы и мышцы кора.', 'Ноги, ягодицы, мышцы кора');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (47, 'Жим ногами в тренажёре', 'https://rutube.ru/video/zhim-nogami-v-trenazhere/', 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Leg_Press_Machine.png', 'Жим ногами в тренажёре – силовое упражнение для нижней части тела. Сидя в тренажёре, ставят ноги на платформу шире плеч и, разгибая колени, выталкивают платформу вперёд. При возвращении делают плавный контроль. Работают квадрицепсы, ягодицы и икроножные мышцы.', 'Ноги, ягодицы, икры');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (48, 'Фронтальные приседания', 'https://rutube.ru/video/frontalnye-prisedaniya/', 'https://upload.wikimedia.org/wikipedia/commons/3/3d/Front_Squat.png', 'Фронтальные приседания – вариант приседа со штангой, когда штангу держат на передней части плеч (на ключицах). Корпус держат более вертикально, чем при обычном приседе. Упражнение нагружает квадрицепсы больше, чем ягодицы и спину.', 'Ноги, мышцы кора');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (49, 'Гоблет-присед', 'https://rutube.ru/video/goblet-prised/', 'https://upload.wikimedia.org/wikipedia/commons/e/ec/Goblet_Squat.png', 'Гоблет-присед – приседание с гантелей или гирей перед грудью (руки держат за «рожки» или за ручку). Во время движения корпус остаётся прямым, бедра опускаются параллельно полу. Отличается большим вовлечением корпуса для стабилизации.', 'Ноги, ягодицы, мышцы кора');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (50, 'Румынская тяга', 'https://rutube.ru/video/rumynskaya-tyaga/', 'https://upload.wikimedia.org/wikipedia/commons/6/6e/Romanian_Deadlift.png', 'Румынская тяга – упражнение со штангой или гантелями для задней поверхности бедра. Слегка сгибая колени и удерживая спину прямой, штангу опускают вдоль бедер до уровня чуть ниже колен, затем возвращаются в исходное положение. Прорабатывает бицепсы бедра, ягодицы и поясницу.', 'Задняя поверхность бедра, ягодицы, спина');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (51, 'Жим ногами узкой постановкой', 'https://rutube.ru/video/zhim-nogami-uzkoy-postanovkoy/', 'https://upload.wikimedia.org/wikipedia/commons/9/9b/Leg_Press_Narrow_Stance.png', 'Жим ногами узкой постановкой – вариант жима ногами в тренажёре, при котором стопы устанавливают близко друг к другу. Такой хват усиливает нагрузку на квадрицепсы, чуть меньше вовлекает ягодицы.', 'Ноги');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (52, 'Сгибание ног лёжа в тренажёре', 'https://rutube.ru/video/sgibanie-nog-lezha-v-trenazhere/', 'https://upload.wikimedia.org/wikipedia/commons/8/8e/Leg_Curl_Machine.png', 'Сгибание ног лёжа – изолирующее упражнение для задней поверхности бедра. Лёжа лицом вниз в тренажёре, упирают лодыжки под валики и сгибают ноги, подтягивая пятки к ягодицам, затем плавно опускают.', 'Задняя поверхность бедра');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (53, 'Разгибание ног в тренажёре', 'https://rutube.ru/video/razgibanie-nog-v-trenazhere/', 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Leg_Extension_Machine.png', 'Разгибание ног – упражнение для квадрицепсов. Сидя в тренажёре, закрепив лодыжки за валик, на выдохе разгибают колени, затем медленно опускают. Полностью изолирует переднюю поверхность бедра.', 'Ноги');
INSERT INTO public.workout_exercises (id, name, video_url, image_url, description, muscle_groups) VALUES (56, 'Подтягивания обратным хватом', 'https://rutube.ru/video/podtyagivaniya-obratnym-khvatom/', 'https://upload.wikimedia.org/wikipedia/commons/6/6c/Chin-up.png', 'Подтягивания обратным хватом – классическое упражнение для спины и бицепсов. Хват снизу (ладони к себе), подтягиваются до уровня подбородка или груди. Нагрузка концентрируется на бицепсах и средней части спины.', 'Спина, бицепс');


--
-- TOC entry 4972 (class 0 OID 41927)
-- Dependencies: 230
-- Data for Name: workout_template; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4968 (class 0 OID 41869)
-- Dependencies: 226
-- Data for Name: workouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.workouts (id, user_id, title, description, date, created_at) VALUES (1, 1, 'Leg Day', 'Heavy squats and lunges', '2025-05-20', '2025-06-02 12:22:55.30152');
INSERT INTO public.workouts (id, user_id, title, description, date, created_at) VALUES (2, 2, 'Cardio Blast', 'HIIT and running', '2025-05-21', '2025-06-02 12:22:55.30152');


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 221
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 2, true);


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 223
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 14, true);


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 227
-- Name: workout_exercises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workout_exercises_id_seq', 45, true);


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 229
-- Name: workout_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workout_template_id_seq', 1, false);


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 225
-- Name: workouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workouts_id_seq', 2, true);


--
-- TOC entry 4795 (class 2606 OID 41826)
-- Name: friends friends_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_pkey PRIMARY KEY (user_id, friend_id);


--
-- TOC entry 4797 (class 2606 OID 41847)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 41862)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 4793 (class 2606 OID 41815)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4789 (class 2606 OID 41807)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4791 (class 2606 OID 41805)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4803 (class 2606 OID 41891)
-- Name: workout_exercises workout_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_exercises
    ADD CONSTRAINT workout_exercises_pkey PRIMARY KEY (id);


--
-- TOC entry 4805 (class 2606 OID 41932)
-- Name: workout_template workout_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_template
    ADD CONSTRAINT workout_template_pkey PRIMARY KEY (id);


--
-- TOC entry 4801 (class 2606 OID 41877)
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);


--
-- TOC entry 4807 (class 2606 OID 41832)
-- Name: friends friends_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES public.users(id);


--
-- TOC entry 4808 (class 2606 OID 41827)
-- Name: friends friends_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4809 (class 2606 OID 41848)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4810 (class 2606 OID 41863)
-- Name: posts posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4806 (class 2606 OID 41816)
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4812 (class 2606 OID 41938)
-- Name: workout_template workout_template_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_template
    ADD CONSTRAINT workout_template_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.workout_exercises(id);


--
-- TOC entry 4813 (class 2606 OID 41933)
-- Name: workout_template workout_template_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workout_template
    ADD CONSTRAINT workout_template_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workouts(id);


--
-- TOC entry 4811 (class 2606 OID 41878)
-- Name: workouts workouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Добавляем внешние ключи для таблицы workouts
ALTER TABLE public.workouts
    ADD CONSTRAINT fk_workouts_user
    FOREIGN KEY (user_id)
    REFERENCES public.users(id)
    ON DELETE CASCADE;

-- Добавляем внешние ключи для таблицы workout_template
ALTER TABLE public.workout_template
    ADD CONSTRAINT fk_workout_template_workout
    FOREIGN KEY (workout_id)
    REFERENCES public.workouts(id)
    ON DELETE CASCADE;

ALTER TABLE public.workout_template
    ADD CONSTRAINT fk_workout_template_exercise
    FOREIGN KEY (exercise_id)
    REFERENCES public.workout_exercises(id)
    ON DELETE CASCADE;

-- Добавляем уникальный индекс для предотвращения дублирования упражнений в тренировке
CREATE UNIQUE INDEX idx_workout_template_unique
    ON public.workout_template(workout_id, exercise_id);

-- Completed on 2025-06-06 13:26:49

--
-- PostgreSQL database dump complete
--

