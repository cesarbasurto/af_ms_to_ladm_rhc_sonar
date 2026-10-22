{% set process_id = dag_run.conf.get('process_id', params.process_id) %}
SET search_path TO
    input_{{ process_id }}, -- Schema modelo simplificado
    output_{{ process_id }}, -- schema modelo LADM extendido
    public;

--====================================================
-- RHC_Derecho: un derecho de acotamiento por cada ronda hidrica.
-- col_baunitRrr se materializa en la columna unidad_rhc_uab_rondahidrica.
--====================================================
insert into rhc_derecho (
    t_basket,
    t_ili_tid,
    tipo,
    descripcion,
    unidad_rhc_uab_rondahidrica,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id
)
select
    (select t_id from output_{{ process_id }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    'Acotar' as tipo,
    left('Acotamiento de la ronda hídrica ' || uab.identificador, 255) as descripcion,
    uab.t_id as unidad_rhc_uab_rondahidrica,
    now() as comienzo_vida_util_version,
    'rhc_derecho' as espacio_de_nombres,
    row_number() over (order by uab.t_id)::text as local_id
from rhc_uab_rondahidrica uab;

