SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- RHC_FuenteAdministrativa  <-  datos de fuente de MS_RHC_RondaHidrica
--====================================================
insert into rhc_fuenteadministrativa (
    t_basket,
    t_ili_tid,
    tipo,
    estado_disponibilidad,
    fecha_documento_fuente,
    nombre,
    url,
    espacio_de_nombres,
    local_id,
    etl_rondahidrica_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    tipo_fuente_administrativa as tipo,
    'Disponible' as estado_disponibilidad,
    fecha_fuente_administrativa as fecha_documento_fuente,
    nombre_fuente_administrativa::varchar as nombre,
    url_fuente_administrativa as url,
    'rhc_fuenteadministrativa' as espacio_de_nombres,
    row_number() over (order by t_id)::text as local_id,
    t_id as etl_rondahidrica_id
from ms_rhc_rondahidrica;
