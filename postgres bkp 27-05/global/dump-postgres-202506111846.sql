PGDMP  2    .                }            postgres    17.0    17.0 ;               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    5    postgres    DATABASE        CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE postgres;
                     postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    4869                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false                       0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    4            �            1259    32772    alunos    TABLE     �  CREATE TABLE public.alunos (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    cpf character(11) NOT NULL,
    telefone character varying(15) NOT NULL,
    cep character varying,
    estado character varying NOT NULL,
    cidade character varying NOT NULL,
    bairro character varying,
    endereco character varying NOT NULL,
    complemento character varying,
    id_plano integer,
    ativo boolean DEFAULT true
);
    DROP TABLE public.alunos;
       public         heap r       postgres    false    4            �            1259    41004    alunos_aulas    TABLE     b   CREATE TABLE public.alunos_aulas (
    aluno_id integer NOT NULL,
    aula_id integer NOT NULL
);
     DROP TABLE public.alunos_aulas;
       public         heap r       postgres    false    4            �            1259    40993    aulas    TABLE     �   CREATE TABLE public.aulas (
    id integer NOT NULL,
    local character varying NOT NULL,
    status_aula integer DEFAULT 1 NOT NULL,
    datahora timestamp without time zone NOT NULL,
    idprofessor integer NOT NULL
);
    DROP TABLE public.aulas;
       public         heap r       postgres    false    4            �            1259    40992    aulas_id_seq    SEQUENCE     �   ALTER TABLE public.aulas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    222    4            �            1259    49222    despesas    TABLE     �   CREATE TABLE public.despesas (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
    DROP TABLE public.despesas;
       public         heap r       postgres    false    4            �            1259    49221    despesas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.despesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.despesas_id_seq;
       public               postgres    false    4    227                       0    0    despesas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.despesas_id_seq OWNED BY public.despesas.id;
          public               postgres    false    226            �            1259    49230    mensalidades    TABLE     �   CREATE TABLE public.mensalidades (
    id integer NOT NULL,
    aluno_id integer NOT NULL,
    nome_aluno text NOT NULL,
    valor numeric(10,2) NOT NULL,
    data_vencimento date NOT NULL,
    esta_pago boolean DEFAULT false
);
     DROP TABLE public.mensalidades;
       public         heap r       postgres    false    4            �            1259    49229    mensalidades_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mensalidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.mensalidades_id_seq;
       public               postgres    false    4    229            	           0    0    mensalidades_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.mensalidades_id_seq OWNED BY public.mensalidades.id;
          public               postgres    false    228            �            1259    32771    pessoas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pessoas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.pessoas_id_seq;
       public               postgres    false    218    4            
           0    0    pessoas_id_seq    SEQUENCE OWNED BY     @   ALTER SEQUENCE public.pessoas_id_seq OWNED BY public.alunos.id;
          public               postgres    false    217            �            1259    49278    planos    TABLE     �   CREATE TABLE public.planos (
    id_plano integer NOT NULL,
    nome character varying(50) NOT NULL,
    valor numeric(10,2) NOT NULL
);
    DROP TABLE public.planos;
       public         heap r       postgres    false    4            �            1259    49277    planos_id_plano_seq    SEQUENCE     �   CREATE SEQUENCE public.planos_id_plano_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.planos_id_plano_seq;
       public               postgres    false    231    4                       0    0    planos_id_plano_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.planos_id_plano_seq OWNED BY public.planos.id_plano;
          public               postgres    false    230            �            1259    40969    professores    TABLE     �  CREATE TABLE public.professores (
    id integer NOT NULL,
    nome character varying NOT NULL,
    cpf character varying NOT NULL,
    telefone character varying NOT NULL,
    cep character varying,
    estado character varying NOT NULL,
    cidade character varying NOT NULL,
    bairro character varying NOT NULL,
    endereco character varying NOT NULL,
    complemento character varying
);
    DROP TABLE public.professores;
       public         heap r       postgres    false    4            �            1259    40968    professores_id_seq    SEQUENCE     �   ALTER TABLE public.professores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.professores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    220    4            �            1259    49213    recebimentos    TABLE     �   CREATE TABLE public.recebimentos (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
     DROP TABLE public.recebimentos;
       public         heap r       postgres    false    4            �            1259    49216    recebimentos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recebimentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.recebimentos_id_seq;
       public               postgres    false    224    4                       0    0    recebimentos_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.recebimentos_id_seq OWNED BY public.recebimentos.id;
          public               postgres    false    225            C           2604    49243 	   alunos id    DEFAULT     g   ALTER TABLE ONLY public.alunos ALTER COLUMN id SET DEFAULT nextval('public.pessoas_id_seq'::regclass);
 8   ALTER TABLE public.alunos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    217    218    218            G           2604    49244    despesas id    DEFAULT     j   ALTER TABLE ONLY public.despesas ALTER COLUMN id SET DEFAULT nextval('public.despesas_id_seq'::regclass);
 :   ALTER TABLE public.despesas ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    227    227            H           2604    49245    mensalidades id    DEFAULT     r   ALTER TABLE ONLY public.mensalidades ALTER COLUMN id SET DEFAULT nextval('public.mensalidades_id_seq'::regclass);
 >   ALTER TABLE public.mensalidades ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    228    229    229            J           2604    49281    planos id_plano    DEFAULT     r   ALTER TABLE ONLY public.planos ALTER COLUMN id_plano SET DEFAULT nextval('public.planos_id_plano_seq'::regclass);
 >   ALTER TABLE public.planos ALTER COLUMN id_plano DROP DEFAULT;
       public               postgres    false    231    230    231            F           2604    49246    recebimentos id    DEFAULT     r   ALTER TABLE ONLY public.recebimentos ALTER COLUMN id SET DEFAULT nextval('public.recebimentos_id_seq'::regclass);
 >   ALTER TABLE public.recebimentos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    224            �          0    32772    alunos 
   TABLE DATA           ~   COPY public.alunos (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento, id_plano, ativo) FROM stdin;
    public               postgres    false    218   �C       �          0    41004    alunos_aulas 
   TABLE DATA           9   COPY public.alunos_aulas (aluno_id, aula_id) FROM stdin;
    public               postgres    false    223   �D       �          0    40993    aulas 
   TABLE DATA           N   COPY public.aulas (id, local, status_aula, datahora, idprofessor) FROM stdin;
    public               postgres    false    222   E       �          0    49222    despesas 
   TABLE DATA           I   COPY public.despesas (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    227   �E       �          0    49230    mensalidades 
   TABLE DATA           c   COPY public.mensalidades (id, aluno_id, nome_aluno, valor, data_vencimento, esta_pago) FROM stdin;
    public               postgres    false    229   !F       �          0    49278    planos 
   TABLE DATA           7   COPY public.planos (id_plano, nome, valor) FROM stdin;
    public               postgres    false    231   fG       �          0    40969    professores 
   TABLE DATA           r   COPY public.professores (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
    public               postgres    false    220   �G       �          0    49213    recebimentos 
   TABLE DATA           M   COPY public.recebimentos (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    224   /H                  0    0    aulas_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.aulas_id_seq', 32, true);
          public               postgres    false    221                       0    0    despesas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.despesas_id_seq', 4, true);
          public               postgres    false    226                       0    0    mensalidades_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.mensalidades_id_seq', 41, true);
          public               postgres    false    228                       0    0    pessoas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.pessoas_id_seq', 87, true);
          public               postgres    false    217                       0    0    planos_id_plano_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.planos_id_plano_seq', 5, true);
          public               postgres    false    230                       0    0    professores_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.professores_id_seq', 38, true);
          public               postgres    false    219                       0    0    recebimentos_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.recebimentos_id_seq', 62, true);
          public               postgres    false    225            T           2606    41008    alunos_aulas alunos_aulas_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT alunos_aulas_pkey PRIMARY KEY (aluno_id, aula_id);
 H   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT alunos_aulas_pkey;
       public                 postgres    false    223    223            R           2606    41000    aulas aulas_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT aulas_pk;
       public                 postgres    false    222            X           2606    49227    despesas despesas_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.despesas
    ADD CONSTRAINT despesas_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.despesas DROP CONSTRAINT despesas_pkey;
       public                 postgres    false    227            Z           2606    49238    mensalidades mensalidades_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.mensalidades
    ADD CONSTRAINT mensalidades_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.mensalidades DROP CONSTRAINT mensalidades_pkey;
       public                 postgres    false    229            L           2606    32779    alunos pessoas_cpf_key 
   CONSTRAINT     P   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_cpf_key UNIQUE (cpf);
 @   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_cpf_key;
       public                 postgres    false    218            N           2606    32777    alunos pessoas_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_pkey;
       public                 postgres    false    218            \           2606    49283    planos planos_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.planos
    ADD CONSTRAINT planos_pkey PRIMARY KEY (id_plano);
 <   ALTER TABLE ONLY public.planos DROP CONSTRAINT planos_pkey;
       public                 postgres    false    231            P           2606    40975    professores professores_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.professores
    ADD CONSTRAINT professores_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.professores DROP CONSTRAINT professores_pk;
       public                 postgres    false    220            V           2606    49220    recebimentos recebimentos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT recebimentos_pkey;
       public                 postgres    false    224            ^           2606    41009    alunos_aulas fk_aluno    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES public.alunos(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aluno;
       public               postgres    false    223    218    4686            ]           2606    49285    alunos fk_alunos_planos    FK CONSTRAINT     ~   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT fk_alunos_planos FOREIGN KEY (id_plano) REFERENCES public.planos(id_plano);
 A   ALTER TABLE ONLY public.alunos DROP CONSTRAINT fk_alunos_planos;
       public               postgres    false    231    4700    218            _           2606    41014    alunos_aulas fk_aula    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aula FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aula;
       public               postgres    false    4690    223    222            �     x�}��n� E����
0<&��j�]^�R%���C����Q�����΁k�Әh��bt>���jk$��h�'<�!&��ГD7۬����7;�H��x��=_�\,�Γƶ\HH����y>��ۡ��Q�W�a��o�_���\�º'�J}
#�:D�M�΁�\�K��}�{��������L�٧���G7.=h�+*���5F���a
1�?�蠭A}��}:�{#�`�PMS��������if˅�-Tƾ=TU�Z|�      �   *   x�3�42�2�46�2�L�9�,��9��	�m 1z\\\ ���      �   �   x�m�1��0k���rIʒ����k�$].)� �m. ���.@��9��#�\�듔 ��	6 #�x�4�0����l##K��I�P2g(�w��w��R"��U�oVM�P�í8����x?�-A�.]{Y�S�,ӎ��42��)ؾ���2\�+u�o�~�f�#��E#V�Ŀ��_b4H�      �   3   x�3�L�)K�J�+IU�44�30�4202�50�50����-H�J����� �
�      �   5  x����n�0�y��@�8��i�N�v�u�H�]$J��q��T��N�����'��^#Φ�\(�QJPR���KPA���o;38q����7��&�������]Y
����́��䊍���4�Wͥj��w�\�ج#=eg]��Yq0�!���-P�$�pp'f2i$�������h$��1)̆Oaf\
3z"M4��,����Bn����ڟ9E��ض��6K>���` �WGOv����ڵ����B9�Rx�|c�����VjR�ݧm��C�O\�!w0��c�$�5T[�      �   9   x�3�4t�t�v�u�s�440�30�2�4B4s#	AT�p�"BT��qqq C��      �   p   x���K�0�ϧ�(q�:�K7�b	B��$N_8C��h��S���
-V$_�s���eS�E9'�ݻ7ǭz��sƾ5�|��2��_G���4ur��BI�<��D���Bn      �   a   x�35�,K�KITHIU(N,H,���H�445�30�4202�50�50��)JJ�IN��23��M�+N��LI��c^�Bpb^I~1���vKd�\1z\\\ !�!�     