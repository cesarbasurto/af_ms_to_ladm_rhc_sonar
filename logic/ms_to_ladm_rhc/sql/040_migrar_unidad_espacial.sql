SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- RHC_UE_CaucePermanente  <-  MS_RHC_ElementoConstituyente (Cauce_Permanente)
--====================================================
insert into rhc_ue_caucepermanente (
    t_basket,
    t_ili_tid,
    area_ha,
    geometria,
    etiqueta,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id,
    etl_elementoconstituyente_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    e.area_ha as area_ha,
    st_force3d(e.geometria) as geometria,
    r.identificador as etiqueta,
    now() as comienzo_vida_util_version,
    'rhc_ue_caucepermanente' as espacio_de_nombres,
    row_number() over (order by e.t_id)::text as local_id,
    e.t_id as etl_elementoconstituyente_id
from ms_rhc_elementoconstituyente e
join ms_rhc_rondahidrica r
    on r.t_id = e.ronda_hidrica
where e.tipo_elemento_constituyente = 'Cauce_Permanente';


--====================================================
-- RHC_UE_FajaParalela  <-  MS_RHC_ElementoConstituyente (Faja_Paralela)
--====================================================
insert into rhc_ue_fajaparalela (
    t_basket,
    t_ili_tid,
    area_ha,
    geometria,
    etiqueta,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id,
    etl_elementoconstituyente_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    e.area_ha as area_ha,
    st_force3d(e.geometria) as geometria,
    r.identificador as etiqueta,
    now() as comienzo_vida_util_version,
    'rhc_ue_fajaparalela' as espacio_de_nombres,
    row_number() over (order by e.t_id)::text as local_id,
    e.t_id as etl_elementoconstituyente_id
from ms_rhc_elementoconstituyente e
join ms_rhc_rondahidrica r
    on r.t_id = e.ronda_hidrica
where e.tipo_elemento_constituyente = 'Faja_Paralela';


--====================================================
-- RHC_UE_AreaProteccionConservacionAferente
--   <-  MS_RHC_ElementoConstituyente (Area_Proteccion_Conservacion_Aferente)
--====================================================
insert into rhc_ue_areaproteccionconservacionaferente (
    t_basket,
    t_ili_tid,
    area_ha,
    geometria,
    etiqueta,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id,
    etl_elementoconstituyente_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    e.area_ha as area_ha,
    st_force3d(e.geometria) as geometria,
    r.identificador as etiqueta,
    now() as comienzo_vida_util_version,
    'rhc_ue_areaproteccionconservacionaferente' as espacio_de_nombres,
    row_number() over (order by e.t_id)::text as local_id,
    e.t_id as etl_elementoconstituyente_id
from ms_rhc_elementoconstituyente e
join ms_rhc_rondahidrica r
    on r.t_id = e.ronda_hidrica
where e.tipo_elemento_constituyente = 'Area_Proteccion_Conservacion_Aferente';


--====================================================
-- RHC_UE_EstrategiaManejoAmbiental  <-  geometria de MS_RHC_EstrategiaManejoAmbiental
--====================================================
insert into rhc_ue_estrategiamanejoambiental (
    t_basket,
    t_ili_tid,
    area_ha,
    geometria,
    etiqueta,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id,
    etl_estrategiamanejoambiental_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    area_ha as area_ha,
    st_force3d(geometria) as geometria,
    estrategia || ' - ' || id_ronda as etiqueta,
    now() as comienzo_vida_util_version,
    'rhc_ue_estrategiamanejoambiental' as espacio_de_nombres,
    row_number() over (order by t_id)::text as local_id,
    t_id as etl_estrategiamanejoambiental_id
from ms_rhc_estrategiamanejoambiental;
