SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- COL_RRRFuente: fuente administrativa de cada responsabilidad
--   Fuente de la ronda a la que pertenece la estrategia
--====================================================
insert into col_rrrfuente (
    t_basket,
    fuente_administrativa,
    rrr_rhc_responsabilidad
)
select distinct
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    f.t_id as fuente_administrativa,
    r.t_id as rrr_rhc_responsabilidad
from rhc_responsabilidad r
join rhc_uab_estrategiamanejoambiental ea
    on ea.t_id = r.unidad_rhc_uab_estrategiamanejoambiental
join rhc_uab_rondahidrica uab
    on uab.t_id = ea.ronda_hidrica
join rhc_fuenteadministrativa f
    on f.etl_rondahidrica_id = uab.etl_rondahidrica_id;

--====================================================
-- COL_RRRFuente: acto administrativo de cada derecho de acotamiento.
--====================================================
insert into col_rrrfuente (
    t_basket,
    fuente_administrativa,
    rrr_rhc_derecho
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    f.t_id as fuente_administrativa,
    d.t_id as rrr_rhc_derecho
from rhc_derecho d
join rhc_uab_rondahidrica uab
    on uab.t_id = d.unidad_rhc_uab_rondahidrica
join rhc_fuenteadministrativa f
    on f.etl_rondahidrica_id = uab.etl_rondahidrica_id;
