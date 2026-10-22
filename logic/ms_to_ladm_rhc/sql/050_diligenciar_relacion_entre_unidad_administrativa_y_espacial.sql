SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- COL_UEBaUnit: unidades espaciales  ->  ronda hidrica
--====================================================
insert into col_uebaunit (
    t_basket,
    ue_rhc_ue_caucepermanente,
    baunit_rhc_uab_rondahidrica
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    ue.t_id as ue_rhc_ue_caucepermanente,
    uab.t_id as baunit_rhc_uab_rondahidrica
from ms_rhc_elementoconstituyente e
join ms_rhc_rondahidrica r
    on r.t_id = e.ronda_hidrica
join rhc_ue_caucepermanente ue
    on ue.etl_elementoconstituyente_id = e.t_id
join rhc_uab_rondahidrica uab
    on uab.etl_rondahidrica_id = r.t_id
where e.tipo_elemento_constituyente = 'Cauce_Permanente';


insert into col_uebaunit (
    t_basket,
    ue_rhc_ue_fajaparalela,
    baunit_rhc_uab_rondahidrica
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    ue.t_id as ue_rhc_ue_fajaparalela,
    uab.t_id as baunit_rhc_uab_rondahidrica
from ms_rhc_elementoconstituyente e
join ms_rhc_rondahidrica r
    on r.t_id = e.ronda_hidrica
join rhc_ue_fajaparalela ue
    on ue.etl_elementoconstituyente_id = e.t_id
join rhc_uab_rondahidrica uab
    on uab.etl_rondahidrica_id = r.t_id
where e.tipo_elemento_constituyente = 'Faja_Paralela';


insert into col_uebaunit (
    t_basket,
    ue_rhc_ue_areaproteccionconservacionaferente,
    baunit_rhc_uab_rondahidrica
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    ue.t_id as ue_rhc_ue_areaproteccionconservacionaferente,
    uab.t_id as baunit_rhc_uab_rondahidrica
from ms_rhc_elementoconstituyente e
join ms_rhc_rondahidrica r
    on r.t_id = e.ronda_hidrica
join rhc_ue_areaproteccionconservacionaferente ue
    on ue.etl_elementoconstituyente_id = e.t_id
join rhc_uab_rondahidrica uab
    on uab.etl_rondahidrica_id = r.t_id
where e.tipo_elemento_constituyente = 'Area_Proteccion_Conservacion_Aferente';


--====================================================
-- COL_UEBaUnit: unidad espacial  ->  estrategia de manejo ambiental
--====================================================
insert into col_uebaunit (
    t_basket,
    ue_rhc_ue_estrategiamanejoambiental,
    baunit_rhc_uab_estrategiamanejoambiental
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    ue.t_id as ue_rhc_ue_estrategiamanejoambiental,
    uab.t_id as baunit_rhc_uab_estrategiamanejoambiental
from ms_rhc_estrategiamanejoambiental e
join rhc_ue_estrategiamanejoambiental ue
    on ue.etl_estrategiamanejoambiental_id = e.t_id
join rhc_uab_estrategiamanejoambiental uab
    on uab.etl_estrategiamanejoambiental_id = e.t_id;
