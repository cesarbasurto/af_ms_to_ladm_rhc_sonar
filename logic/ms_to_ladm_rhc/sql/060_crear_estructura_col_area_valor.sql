{% set process_id = dag_run.conf.get('process_id', params.process_id) %}
{% set topic_rhc = "'LADM_COL_v_1_0_0_Ext_RHC.RHC'" %}
{% set tipo_area_grafica = "'Area_Grafica'" %}
SET search_path TO
    input_{{ process_id }}, -- Schema modelo simplificado
    output_{{ process_id }}, -- schema modelo LADM extendido
    public;

--====================================================
-- COL_AreaValor: area grafica de cada unidad espacial
--====================================================
insert into col_areavalor (
    t_basket,
    tipo,
    area,
    rhc_ue_caucepermanente_area
)
select
    (select t_id from output_{{ process_id }}.t_ili2db_basket where topic = {{ topic_rhc }} limit 1) as t_basket,
    {{ tipo_area_grafica }} as tipo,
    area_ha as area,
    t_id as rhc_ue_caucepermanente_area
from rhc_ue_caucepermanente
where area_ha is not null;


insert into col_areavalor (
    t_basket,
    tipo,
    area,
    rhc_ue_fajaparalela_area
)
select
    (select t_id from output_{{ process_id }}.t_ili2db_basket where topic = {{ topic_rhc }} limit 1) as t_basket,
    {{ tipo_area_grafica }} as tipo,
    area_ha as area,
    t_id as rhc_ue_fajaparalela_area
from rhc_ue_fajaparalela
where area_ha is not null;


insert into col_areavalor (
    t_basket,
    tipo,
    area,
    rhc__rprtccnsrvcnfrnte_area
)
select
    (select t_id from output_{{ process_id }}.t_ili2db_basket where topic = {{ topic_rhc }} limit 1) as t_basket,
    {{ tipo_area_grafica }} as tipo,
    area_ha as area,
    t_id as rhc__rprtccnsrvcnfrnte_area
from rhc_ue_areaproteccionconservacionaferente
where area_ha is not null;


insert into col_areavalor (
    t_basket,
    tipo,
    area,
    rhc_ue_estrtgmnjmbntal_area
)
select
    (select t_id from output_{{ process_id }}.t_ili2db_basket where topic = {{ topic_rhc }} limit 1) as t_basket,
    {{ tipo_area_grafica }} as tipo,
    area_ha as area,
    t_id as rhc_ue_estrtgmnjmbntal_area
from rhc_ue_estrategiamanejoambiental
where area_ha is not null;
