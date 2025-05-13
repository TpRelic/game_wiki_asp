% s(CASP) Programming
:- use_module(library(scasp)).
:- style_check(-discontiguous).
:- style_check(-singleton).
%:- set_prolog_flag(scasp_unknown, fail).

cata_level(X) :- X #> 0.  % cata level is some value above 0

% even loops for weapon stats
:- dynamic(price/1).
price(low) :- not price(mid), not price(high).
price(mid) :- not price(low), not price(high).
price(high) :- not price(low), not price(mid).

:- dynamic(damage/1).
damage(none) :- not damage(low), not damage(mid), not damage(high).
damage(low) :- not damage(none), not damage(mid), not damage(high).
damage(mid) :- not damage(low), not damage(none), not damage(high).
damage(high) :- not damage(low), not damage(mid), not damage(none).

:- dynamic(class/1).
class(healer) :- not class(mage), not class(berserker), not class(archer), not class(tank).
class(mage) :- not class(healer), not class(berserker), not class(archer), not class(tank).
class(berserker) :- not class(mage), not class(healer), not class(archer), not class(tank).
class(archer) :- not class(mage), not class(berserker), not class(healer), not class(tank).
class(tank) :- not class(mage), not class(berserker), not class(archer), not class(healer).

:- dynamic(stage/1).
stage(early) :- not stage(mid), not stage(late).
stage(mid) :- not stage(early), not stage(late).
stage(late) :- not stage(early), not stage(mid).

requires(X) :- get_requirements(X, CraftReqs), level_requirement(X, LevelReq),
	price(X, Price), price(Price), class(X, Class), class(Class), damage(X, Damage), damage(Damage), stage(X, Stage), stage(Stage).

get_requirements(hyperion, [necrons_handle_qty(1), necrons_handle_req(R1), wither_catalyst_qty(24), wither_catalyst_req(R2), lasr_eye_qty(8), lasr_eye_req(R3), hyperion_extras(R4)]) :-
    requires(necrons_handle, R1), requires(wither_catalyst, R2), requires(lasr_eye, R3), requires(hyperion_extras, R4).
requires(necrons_handle, floor7). requires(wither_catalyst, floor7). requires(lasr_eye, floor7). requires(hyperion_extras, wither_impact).
level_requirement(hyperion, level(X)) :- cata_level(X), X #>= 24.  % you need cata 24
price(hyperion, Price) :- price(high). class(hyperion, Class) :- class(mage).
damage(hyperion, Damage) :- damage(high). stage(hyperion, Stage) :- stage(late).

get_requirements(bonzos_staff, [coins_qty(R1), bonzos_staff_req(R2)]) :-
    cost(bonzos_staff, R1), requires(bonzos_staff, R2).
cost(bonzos_staff, X) :- X #>= 2100000. requires(bonzos_staff, floor1).
level_requirement(bonzos_staff, level(X)) :- cata_level(X), X #>= 1.
price(bonzos_staff, Price) :- price(low). class(bonzos_staff, Class) :- class(mage).
damage(bonzos_staff, Damage) :- damage(low). stage(bonzos_staff, Stage) :- stage(early).

get_requirements(spirit_scepter, [enchanted_lapis_block_qty(6), spirit_wing_qty(3), spirit_wing_req(R1)]) :-
    requires(spirit_wing, R1).
requires(spirit_wing, floor4).
level_requirement(spirit_scepter, level(X)) :- cata_level(X), X #>= 9.
price(spirit_scepter, Price) :- price(mid). class(spirit_scepter, Class) :- class(mage).
damage(spirit_scepter, Damage) :- damage(low). stage(spirit_scepter, Stage) :- stage(mid).

get_requirements(midas_staff, [dark_auction, darker_auctions_req(R1)]) :-
    requires(dark_auction, R1).
requires(dark_auction, mayor(scorpius)).
level_requirement(midas_staff, level(X)) :- cata_level(X), X #>= 25.
price(midas_staff, Price) :- price(mid). class(midas_staff, Class) :- class(mage).
damage(midas_staff, Damage) :- damage(high). stage(midas_staff, Stage) :- stage(mid).

get_requirements(dragon_shortbow, [lone_adventurer_quest, lone_adventurer_quest_req(R1)]) :-
    requires(lone_adventurer_quest, R1).
requires(lone_adventurer_quest, the_end).
level_requirement(dragon_shortbow, level(X)) :- cata_level(X), X #>= 8.
price(dragon_shortbow, Price) :- price(low). class(dragon_shortbow, Class) :- class(archer).
damage(dragon_shortbow, Damage) :- damage(low). stage(dragon_shortbow, Stage) :- stage(early).

get_requirements(juju_shortbow, [juju_shortbow_req(R1), enchanted_string_qty(192), enchanted_eye_of_ender_qty(32), enchanted_quartz(32), null_ovoid_qty(32)]) :-
	requires(juju_shortbow, R1).
requires(juju_shortbow, enderman_slayer(X)) :- X #>= 5.
level_requirement(juju_shortbow, level(X)) :- cata_level(X), X #>= 15.
price(juju_shortbow, Price) :- price(mid). class(juju_shortbow, Class) :- class(archer).
damage(juju_shortbow, Damage) :- damage(mid). stage(juju_shortbow, Stage) :- stage(mid).

get_requirements(terminator, [tarantula_silk_qty(128), null_blade_qty(3), braided_griffin_feather_qty(4), braided_griffin_feather_req(R1), tessellated_ender_pearl_qty(8), null_ovoid_qty(32), judgement_core_qty(1), judgement_core_req(R2), crit_chance_req(R3), extra_req(R4)]) :-
	requires(braided_griffin_feather, R1), requires(judgement_core, R2), requires(terminator, R3), requires(terminator_extras, R4).
requires(braided_griffin_feather, mayor(diana)). requires(judgement_core, enderman_slayer(X)) :- X #>= 7. requires(terminator, crit_chance(X)) :- (X / 4) #>= 100. requires(terminator_extras, shoots_3_arrows).
level_requirement(terminator, level(X)) :- cata_level(X), X #>= 27.
price(terminator, Price) :- price(high). class(terminator, Class) :- class(archer).
damage(terminator, Damage) :- damage(high). stage(terminator, Stage) :- stage(late).

get_requirements(void_sword, [lone_adventurer_quest, lone_adventurer_quest_req(R1)]) :-
    requires(lone_adventurer_quest, R1).
requires(lone_adventurer_quest, the_end).
level_requirement(void_sword, level(X)) :- cata_level(X), X #>= 8.
price(void_sword, Price) :- price(low). class(void_sword, Class) :- class(berserker).
damage(void_sword, Damage) :- damage(low). stage(void_sword, Stage) :- stage(early).

get_requirements(shadow_fury, [coins_qty(R1), shadow_fury(R2)]) :-
    cost(shadow_fury, R1), requires(shadow_fury, R2).
cost(shadow_fury, X) :- X #>= 15000000. requires(shadow_fury, floor5).
level_requirement(shadow_fury, level(X)) :- cata_level(X), X #>= 14.
price(shadow_fury, Price) :- price(mid). class(shadow_fury, Class) :- class(berserker).
damage(shadow_fury, Damage) :- damage(mid). stage(shadow_fury, Stage) :- stage(mid).

get_requirements(dark_claymore, [coins_qty(R1), dark_claymore_req(R2), chimera_ench_req(R3)]) :-
    cost(dark_claymore, R1), requires(dark_claymore, R2), requires(chimera, R3).
cost(dark_claymore, X) :- X #>= 150000000. requires(dark_claymore, masterfloor7). requires(chimera, mayor(diana)).
level_requirement(dark_claymore, level(X)) :- cata_level(X), X #>= 36.
price(dark_claymore, Price) :- price(high). class(dark_claymore, Class) :- class(berserker).
damage(dark_claymore, Damage) :- damage(high). stage(dark_claymore, Stage) :- stage(late).

get_requirements(soul_whip, [coins_qty(R1), soul_whip_req(R2), soul_whip_extras(R3)]) :-
    cost(soul_whip, R1), requires(soul_whip, R2), requires(soul_whip_extras, R3).
cost(soul_whip, X) :- X #>= 11000000. requires(soul_whip, fishing_level(X)) :- X #>= 26. requires(soul_whip_extras, applies_debuff).
level_requirement(soul_whip, level(X)) :- cata_level(X), X #>= 23.
price(soul_whip, Price) :- price(mid). class(soul_whip, Class) :- class(healer).
damage(soul_whip, Damage) :- damage(low). stage(soul_whip, Stage) :- stage(mid).

get_requirements(ice_spray_wand, [coins_qty(R1), ice_spray_wand_extras(R2)]) :-
    cost(ice_spray_wand, R1), requires(ice_spray_wand_extras, R2).
cost(ice_spray_wand, X):- X #>= 18000000. requires(ice_spray_wand_extras, applies_debuff).
level_requirement(ice_spray_wand, level(X)) :- cata_level(X), X #>= 20.
price(ice_spray_wand, Price) :- price(mid). class(ice_spray_wand, Class) :- class(healer).
damage(ice_spray_wand, Damage) :- damage(low). stage(ice_spray_wand, Stage) :- stage(mid).

get_requirements(jingle_bells, [chicken_race_quest, chicken_race_quest_req(R1), jingle_bells_extras(R2)]) :-
    requires(chicken_race_quest, R1), requires(jingle_bells_extras, R2).
requires(chicken_race_quest, winter). requires(jingle_bells_extras, draws_aggro).
level_requirement(jingle_bells, level(X)) :- cata_level(X), X #>= 0.
price(jingle_bells, Price) :- price(low). class(jingle_bells, Class) :- class(tank).
damage(jingle_bells, Damage) :- damage(none). stage(jingle_bells, Stage) :- stage(early).

get_requirements(axe_of_the_shredded, [shard_of_the_shredded_qty(4), shard_of_the_shredded_req(R1), revenant_viscera_qty(256), reaper_falchion_qty(1), axe_of_the_shredded_extras(R2)]) :-
    requires(shard_of_the_shredded, R1), requires(axe_of_the_shredded_extras, R2).
requires(shard_of_the_shredded, zombie_slayer(X)) :- X #>= 8. requires(axe_of_the_shredded_extras, draws_aggro).
level_requirement(axe_of_the_shredded, level(X)) :- cata_level(X), X #>= 25.
price(axe_of_the_shredded, Price) :- price(mid). class(axe_of_the_shredded, Class) :- class(tank).
damage(axe_of_the_shredded, Damage) :- damage(mid). stage(axe_of_the_shredded, Stage) :- stage(mid).

get_requirements(astraea, [necrons_handle_qty(1), necrons_handle_req(R1), wither_catalyst_qty(24), wither_catalyst_req(R2), jolly_pink_rock_qty(8), jolly_pink_rock_req(R3), hyperion_extras(R4)]) :-
    requires(necrons_handle, R1), requires(wither_catalyst, R2), requires(jolly_pink_rock, R3), requires(hyperion_extras, R4).
requires(jolly_pink_rock, floor7).
level_requirement(astraea, level(X)) :- cata_level(X), X #>= 24.  % you need cata 24
price(astraea, Price) :- price(high). class(astraea, Class) :- class(tank).
damage(astraea, Damage) :- damage(mid). stage(astraea, Stage) :- stage(late).

% Example Query
% item(hyperion). ? check_item(Reqs)
% price(high).
% class(mage).
% query(item) to look for some object X by specific name
check_item(X) :-
    item(X), requires(X).
% query(setup) to look for some object X by existing facts.
check_setup(X) :-
    price(P), class(C), damage(D), stage(S), requires(X).

% then some psuedo even loops to get all of a certain type
search_price(Items) :- price(P), not missing_price(Items, P).
missing_price(Items, P) :- price(X, P), not in_list(X, Items).

search_class(Items) :- class(C), not missing_class(Items, C).
missing_class(Items, C) :- class(X, C), not in_list(X, Items).

search_damage(Items) :- damage(D), not missing_damage(Items, D).
missing_damage(Items, D) :- damage(X, D), not in_list(X, Items).

search_stage(Items) :- stage(S), not missing_stage(Items, S).
missing_stage(Items, S) :- stage(X, S), not in_list(X, Items).

% Helper predicate to build the list (still wip)
list_Xs([]).	% Base case: empty list
list_Xs([X|Rest]) :- not in_list(X, Rest), list_Xs(Rest).

% Auxiliary predicate to check if an element is in the list
in_list(X, [X|_]).
in_list(X, [_|T]) :- in_list(X, T).

