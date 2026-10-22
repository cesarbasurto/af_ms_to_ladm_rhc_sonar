SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- RHC_UAB_RondaHidrica  <-  MS_RHC_RondaHidrica
--====================================================
insert into rhc_uab_rondahidrica (
    t_basket,
    t_ili_tid,
    identificador,
    nombre_ronda_hidrica,
    nombre,
    tipo_cuerpo_agua,
    longitud_acotada_km,
    observaciones,
    tipo,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id,
    etl_rondahidrica_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    identificador as identificador,
    nombre as nombre_ronda_hidrica,
    nombre as nombre,
    tipo_cuerpo_agua as tipo_cuerpo_agua,
    longitud_acotada_km as longitud_acotada_km,
    observaciones as observaciones,
    'Ambiente_Desarrollo_Sostenible' as tipo,
    now() as comienzo_vida_util_version,
    'rhc_uab_rondahidrica' as espacio_de_nombres,
    row_number() over (order by t_id)::text as local_id,
    t_id as etl_rondahidrica_id
from ms_rhc_rondahidrica;


--====================================================
-- RHC_UAB_EstrategiaManejoAmbiental  <-  MS_RHC_EstrategiaManejoAmbiental
--   La relacion con la ronda se resuelve por Id_Ronda = Identificador
--====================================================
insert into rhc_uab_estrategiamanejoambiental (
    t_basket,
    t_ili_tid,
    estrategia,
    ronda_hidrica,
    nombre,
    tipo,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id,
    etl_estrategiamanejoambiental_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    e.estrategia as estrategia,
    uab.t_id as ronda_hidrica,
    e.estrategia || ' - ' || e.id_ronda as nombre,
    'Ambiente_Desarrollo_Sostenible' as tipo,
    now() as comienzo_vida_util_version,
    'rhc_uab_estrategiamanejoambiental' as espacio_de_nombres,
    row_number() over (order by e.t_id)::text as local_id,
    e.t_id as etl_estrategiamanejoambiental_id
from ms_rhc_estrategiamanejoambiental e
join ms_rhc_rondahidrica r
    on r.identificador = e.id_ronda
join rhc_uab_rondahidrica uab
    on uab.etl_rondahidrica_id = r.t_id;
