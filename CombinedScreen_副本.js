// JSON Data
const heightWeightData = [
  {"height_min": 41.4, "height_max": 47.2, "weight": 3, "color": "grey"},
  {"height_min": 47.2, "height_max": 53.3, "weight": 4, "color": "grey"},
  {"height_min": 53.3, "height_max": 58.8, "weight": 5, "color": "grey"},
  {"height_min": 58.8, "height_max": 63.7, "weight": 6, "color": "pink"},
  {"height_min": 63.7, "height_max": 68.3, "weight": 7, "color": "pink"},
  {"height_min": 68.3, "height_max": 72.6, "weight": 8, "color": "red"},
  {"height_min": 72.6, "height_max": 76.6, "weight": 9, "color": "red"},
  {"height_min": 76.6, "height_max": 80.4, "weight": 10, "color": "purple"},
  {"height_min": 80.4, "height_max": 84.1, "weight": 11, "color": "purple"},
  {"height_min": 84.1, "height_max": 87.5, "weight": 12, "color": "yellow"},
  {"height_min": 87.5, "height_max": 90.9, "weight": 13, "color": "yellow"},
  {"height_min": 90.9, "height_max": 94.0, "weight": 14, "color": "yellow"},
  {"height_min": 94.0, "height_max": 97.1, "weight": 15, "color": "white"},
  {"height_min": 97.1, "height_max": 100.1, "weight": 16, "color": "white"},
  {"height_min": 100.1, "height_max": 103.0, "weight": 17, "color": "white"},
  {"height_min": 103.0, "height_max": 105.8, "weight": 18, "color": "white"},
  {"height_min": 105.8, "height_max": 108.6, "weight": 19, "color": "blue"},
  {"height_min": 108.6, "height_max": 111.2, "weight": 20, "color": "blue"},
  {"height_min": 111.2, "height_max": 113.8, "weight": 21, "color": "blue"},
  {"height_min": 113.8, "height_max": 116.4, "weight": 22, "color": "blue"},
  {"height_min": 116.4, "height_max": 118.9, "weight": 23, "color": "blue"},
  {"height_min": 118.9, "height_max": 121.2, "weight": 24, "color": "orange"},
  {"height_min": 121.2, "height_max": 123.6, "weight": 25, "color": "orange"},
  {"height_min": 123.6, "height_max": 126.0, "weight": 26, "color": "orange"},
  {"height_min": 126.0, "height_max": 128.3, "weight": 27, "color": "orange"},
  {"height_min": 128.3, "height_max": 130.5, "weight": 28, "color": "orange"},
  {"height_min": 130.5, "height_max": 132.7, "weight": 29, "color": "orange"},
  {"height_min": 132.7, "height_max": 134.8, "weight": 30, "color": "green"},
  {"height_min": 134.8, "height_max": 137.0, "weight": 31, "color": "green"},
  {"height_min": 137.0, "height_max": 139.0, "weight": 32, "color": "green"},
  {"height_min": 139.0, "height_max": 141.1, "weight": 33, "color": "green"},
  {"height_min": 141.1, "height_max": 143.2, "weight": 34, "color": "green"},
  {"height_min": 143.2, "height_max": 145.1, "weight": 35, "color": "green"},
  {"height_min": 145.1, "height_max": 147.2, "weight": 36, "color": "green"},
  {"height_min": 147.2, "height_max": 149.1, "weight": 37, "color": "green"}
];

上面这是最初，每一段的身高区间值都会有对应的颜色。

针对不同的颜色，使用的药剂剂量也不同。


  dosageMap = {
    grey: {
      // Airway equipment
      Miller_Blade: "1",
      Mac_Blade: "1",
      Airtraq: "0",
      VividTrac: "",
      Endotracheal_Tube_Cuffed:"2.5-3.0",
      LMA:"1",
      KingTube:"0-1",
      iGel:"1",

      // Airway emergency
      Etomidate_IV_IO:"1.2 mg/0.6mL",
      Ketamine_IV_IO:"10 mg/0.2mL",
      Succinylcholine_IV_IO:"8 mg/0.4 mL",
      Rocuronium_IV_IO:"5 mg/0.5 mL",
      Fentanyl_IV_IO: "5 mcg/0.1 mL",
      Midazolam_IV_IO: "0.5 mg/0.1 mL",
      Lorazepam_IV_IO:"0.4 mg/0.2 mL",
      Ketamine_IV_IO:"10 mg/0.2 mL",

      // Cardiac arrest
      shock_1st:"8 J",
      shock_2nd:"16 J",
      shock_3rd:"16 - 50 J",
      Epinephrine_1mg_10mL_IV: "0.05 mg/0.5 mL",
      Atropine_IV_IO_ETT:"0.1 mg/1 mL",
      Magnesium_sulfate_IV:"150 mg/0.3 mL",
      Epinephrine_1mg_1mL_ETT:"0.5 mg/0.5mL",
      Amiodarone_IV:"20 mg/0.4mL",
      Lidocaine_IV:"4 mg/0.2 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"0.4 mcg/min (6 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"4 mcg/min (60 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.1 mg/0.1 mL",
      Diphenhydramine_IV_IM:"5 mg/0.1 mL",
      Famotidine_IV:"2 mg/0.2 mL",
      Methylprednisolone_IV:"6.3 mg/0.1 mL",
      
      // Pain
      Fentanyl_IN:"5 mcg/0.1 mL",
      Fentanyl_IV:"5 mcg/0.1 mL",
      Ketorolac_IV:"",
      Tylenol_PO:"60 mg/1.9 mL",
      Ibuprofen_PO:"",

      // Seizure;
      Midazolam_IN:"1 mg/0.2 mL",
      Midazolam_IV:"0.5 mg/0.1 mL",
      Lorazepam_IV:"0.4 mg/0.2 mL",
      D10_IV:"12 mL"
    },
    pink: {
      // Airway equipment
      Miller_Blade: "1",
      Mac_Blade: "1",
      Airtraq: "0",
      VividTrac: "",
      Endotracheal_Tube_Cuffed:"3.0-3.5",
      LMA:"1.5",
      KingTube:"1",
      iGel:"1.5",

      // Airway emergency
      Etomidate_IV_IO:"2 mg/1 mL",
      Ketamine_IV_IO:"15 mg/0.3 mL",
      Succinylcholine_IV_IO:"14 mg/0.7 mL",
      Rocuronium_IV_IO:"6 mg/0.6 mL",
      Fentanyl_IV_IO: "5 mcg/0.1 mL",
      Midazolam_IV_IO: "0.5 mg/0.1 mL",
      Lorazepam_IV_IO:"0.6 mg/0.3 mL",
      Ketamine_IV_IO:"15 mg/0.3 mL",

      // Cardiac arrest
      shock_1st:"14 J",
      shock_2nd:"28 J",
      shock_3rd:"18 - 70 J",
      Epinephrine_1mg_10mL_IV: "0.07 mg/0.7 mL",
      Atropine_IV_IO_ETT:"0.12 mg/1.2 mL",
      Magnesium_sulfate_IV:"250 mg/0.5 mL",
      Epinephrine_1mg_1mL_ETT:"0.7 mg/0.7 mL",
      Amiodarone_IV:"35 mg/0.7 mL",
      Lidocaine_IV:"6 mg/0.3 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"0.6 mcg/min (9 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"6 mcg/min (90 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.1 mg/0.1 mL",
      Diphenhydramine_IV_IM:"5 mg/0.1 mL",
      Famotidine_IV:"4 mg/0.4 mL",
      Methylprednisolone_IV:"12.5 mg/0.2 mL",
      
      // Pain
      Fentanyl_IN:"10 mcg/0.2 mL",
      Fentanyl_IV:"5 mcg/0.1 mL",
      Ketorolac_IV:"3 mg/0.1 mL",
      Tylenol_PO:"90 mg/2.8 mL",
      Ibuprofen_PO:"60 mg/3 mL",

      // Seizure;
      Midazolam_IN:"1.5 mg/0.3 mL",
      Midazolam_IV:"1 mg/0.2 mL",
      Lorazepam_IV:"0.6 mg/0.3 mL",
      D10_IV:"20 mL"
    },
    red: {
      // Airway equipment
      Miller_Blade: "1",
      Mac_Blade: "1",
      Airtraq: "0",
      VividTrac: "Peds",
      Endotracheal_Tube_Cuffed:"3.5-4.0",
      LMA:"1.5",
      KingTube:"1",
      iGel:"1.5",

      // Airway emergency
      Etomidate_IV_IO:"2.6 mg/1.3 mL",
      Ketamine_IV_IO:"15 mg/0.3 mL",
      Succinylcholine_IV_IO:"18 mg/0.9 mL",
      Rocuronium_IV_IO:"8 mg/0.8 mL",
      Fentanyl_IV_IO: "10 mcg/0.2 mL",
      Midazolam_IV_IO: "1 mg/0.2 mL",
      Lorazepam_IV_IO:"0.8 mg/0.4 mL",
      Ketamine_IV_IO:"15 mg/0.3 mL",

      // Cardiac arrest
      shock_1st:"18 J",
      shock_2nd:"36 J",
      shock_3rd:"36 - 90 J",
      Epinephrine_1mg_10mL_IV: "0.09 mg/0.9 mL",
      Atropine_IV_IO_ETT:"0.18 mg/1.8 mL",
      Magnesium_sulfate_IV:"350 mg/0.7 mL",
      Epinephrine_1mg_1mL_ETT:"0.9 mg/0.9 mL",
      Amiodarone_IV:"45 mg/0.9 mL",
      Lidocaine_IV:"8 mg/0.4 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"0.8 mcg/min (12 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"8 mcg/min (120 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.1 mg/0.1 mL",
      Diphenhydramine_IV_IM:"10 mg/0.2 mL",
      Famotidine_IV:"5 mg/0.5 mL",
      Methylprednisolone_IV:"19 mg/0.3 mL",
      
      // Pain
      Fentanyl_IN:"15 mcg/0.3 mL",
      Fentanyl_IV:"10 mcg/0.2 mL",
      Ketorolac_IV:"3 mg/0.1 mL",
      Tylenol_PO:"120 mg/3.8 mL",
      Ibuprofen_PO:"80 mg/4 mL",

      // Seizure;
      Midazolam_IN:"2 mg/0.4 mL",
      Midazolam_IV:"1 mg/0.2 mL",
      Lorazepam_IV:"0.8 mg/0.4 mL",
      D10_IV:"26 mL"
    },
    purple: {
      // Airway equipment
      Miller_Blade: "2",
      Mac_Blade: "2",
      Airtraq: "1",
      VividTrac: "Peds",
      Endotracheal_Tube_Cuffed:"3.5-4.0",
      LMA:"2",
      KingTube:"1",
      iGel:"1.5-2",

      // Airway emergency
      Etomidate_IV_IO:"3.2 mg/1.6 mL",
      Ketamine_IV_IO:"20 mg/0.4 mL",
      Succinylcholine_IV_IO:"20 mg/1 mL",
      Rocuronium_IV_IO:"10 mg/1 mL",
      Fentanyl_IV_IO: "10 mcg/0.2 mL",
      Midazolam_IV_IO: "1 mg/0.2 mL",
      Lorazepam_IV_IO:"1 mg/0.5 mL",
      Ketamine_IV_IO:"20 mg/0.4 mL",

      // Cardiac arrest
      shock_1st:"22 J",
      shock_2nd:"44 J",
      shock_3rd:"44 - 110 J",
      Epinephrine_1mg_10mL_IV: "0.1 mg/1 mL",
      Atropine_IV_IO_ETT:"0.2 mg/2 mL",
      Magnesium_sulfate_IV:"400 mg/0.8 mL",
      Epinephrine_1mg_1mL_ETT:"1 mg/1 mL",
      Amiodarone_IV:"55 mg/1.1 mL",
      Lidocaine_IV:"10 mg/0.5 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"1 mcg/min (15 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"10 mcg/min (150 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.1 mg/0.1 mL",
      Diphenhydramine_IV_IM:"10 mg/0.2 mL",
      Famotidine_IV:"6 mg/0.6 mL",
      Methylprednisolone_IV:"19 mg/0.3 mL",
      
      // Pain
      Fentanyl_IN:"15 mcg/0.3 mL",
      Fentanyl_IV:"10 mcg/0.2 mL",
      Ketorolac_IV:"6 mg/0.2 mL",
      Tylenol_PO:"150 mg/4.7 mL",
      Ibuprofen_PO:"100 mg/5 mL",

      // Seizure;
      Midazolam_IN:"2 mg/0.4 mL",
      Midazolam_IV:"1 mg/0.2 mL",
      Lorazepam_IV:"1 mg/0.5 mL",
      D10_IV:"32 mL"
    },
    yellow: {
      // Airway equipment
      Miller_Blade: "2",
      Mac_Blade: "2",
      Airtraq: "1",
      VividTrac: "Peds",
      Endotracheal_Tube_Cuffed:"4.0-4.5",
      LMA:"2",
      KingTube:"2",
      iGel:"2",

      // Airway emergency
      Etomidate_IV_IO:"4 mg/2 mL",
      Ketamine_IV_IO:"25 mg/0.5 mL",
      Succinylcholine_IV_IO:"26 mg/1.3 mL",
      Rocuronium_IV_IO:"12 mg/1.2 mL",
      Fentanyl_IV_IO: "15 mcg/0.3 mL",
      Midazolam_IV_IO: "1.5 mg/0.3 mL",
      Lorazepam_IV_IO:"1.2 mg/0.6 mL",
      Ketamine_IV_IO:"25 mg/0.5 mL",

      // Cardiac arrest
      shock_1st:"25 J",
      shock_2nd:"50 J",
      shock_3rd:"50 - 140 J",
      Epinephrine_1mg_10mL_IV: "0.13 mg/1.3 mL",
      Atropine_IV_IO_ETT:"0.25 mg/2.5 mL",
      Magnesium_sulfate_IV:"500 mg/1 mL",
      Epinephrine_1mg_1mL_ETT:"1.3 mg/1.3 mL",
      Amiodarone_IV:"65 mg/1.3 mL",
      Lidocaine_IV:"12 mg/0.6 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"1.2 mcg/min (18 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"10 mcg/min (150 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.1 mg/0.1 mL",
      Diphenhydramine_IV_IM:"15 mg/0.3 mL",
      Famotidine_IV:"7 mg/0.7 mL",
      Methylprednisolone_IV:"25 mg/0.4 mL",
      
      // Pain
      Fentanyl_IN:"20 mcg/0.4 mL",
      Fentanyl_IV:"15 mcg/0.3 mL",
      Ketorolac_IV:"6 mg/0.2 mL",
      Tylenol_PO:"180 mg/5.6 mL",
      Ibuprofen_PO:"140 mg/7 mL",

      // Seizure;
      Midazolam_IN:"2.5 mg/0.5 mL",
      Midazolam_IV:"1.5 mg/0.3 mL",
      Lorazepam_IV:"1.2 mg/0.6 mL",
      D10_IV:"39 mL"
    },
    white: {
      // Airway equipment
      Miller_Blade: "2",
      Mac_Blade: "2",
      Airtraq: "1",
      VividTrac: "Peds",
      Endotracheal_Tube_Cuffed:"4.5-5.0",
      LMA:"2",
      KingTube:"2",
      iGel:"2",

      // Airway emergency
      Etomidate_IV_IO:"5 mg/2.5 mL",
      Ketamine_IV_IO:"30 mg/0.6 mL",
      Succinylcholine_IV_IO:"32 mg/1.6 mL",
      Rocuronium_IV_IO:"16 mg/1.6 mL",
      Fentanyl_IV_IO: "15 mcg/0.3 mL",
      Midazolam_IV_IO: "2 mg/0.4 mL",
      Lorazepam_IV_IO:"1.6 mg/0.8 mL",
      Ketamine_IV_IO:"30 mg/0.6 mL",

      // Cardiac arrest
      shock_1st:"35 J",
      shock_2nd:"70 J",
      shock_3rd:"70 - 160 J",
      Epinephrine_1mg_10mL_IV: "0.15 mg/1.5 mL",
      Atropine_IV_IO_ETT:"0.35 mg/3.5 mL",
      Magnesium_sulfate_IV:"650 mg/1.3 mL",
      Epinephrine_1mg_1mL_ETT:"1.5 mg/1.5 mL",
      Amiodarone_IV:"85 mg/1.7 mL",
      Lidocaine_IV:"16 mg/0.8 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"1.6 mcg/min (24 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"10 mcg/min (150 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.2 mg/0.2 mL",
      Diphenhydramine_IV_IM:"15 mg/0.3 mL",
      Famotidine_IV:"8 mg/0.8 mL",
      Methylprednisolone_IV:"31 mg/0.5 mL",
      
      // Pain
      Fentanyl_IN:"25 mcg/0.5 mL",
      Fentanyl_IV:"15 mcg/0.3 mL",
      Ketorolac_IV:"9 mg/0.3 mL",
      Tylenol_PO:"240 mg/7.5 mL",
      Ibuprofen_PO:"160 mg/8 mL",

      // Seizure;
      Midazolam_IN:"3 mg/0.6 mL",
      Midazolam_IV:"2 mg/0.4 mL",
      Lorazepam_IV:"1.6 mg/0.8 mL",
      D10_IV:"50 mL"
    },
    blue: {
      // Airway equipment
      Miller_Blade: "2",
      Mac_Blade: "2",
      Airtraq: "1",
      VividTrac: "Peds",
      Endotracheal_Tube_Cuffed:"5.0-5.5",
      LMA:"2.5",
      KingTube:"2",
      iGel:"2",

      // Airway emergency
      Etomidate_IV_IO:"6.2 mg/3.1 mL",
      Ketamine_IV_IO:"40 mg/0.8 mL",
      Succinylcholine_IV_IO:"42 mg/2.1 mL",
      Rocuronium_IV_IO:"21 mg/2.1 mL",
      Fentanyl_IV_IO: "20 mcg/0.4 mL",
      Midazolam_IV_IO: "2 mg/0.4 mL",
      Lorazepam_IV_IO:"2 mg/2 mL",
      Ketamine_IV_IO:"40 mg/0.8 mL",

      // Cardiac arrest
      shock_1st:"45 J",
      shock_2nd:"90 J",
      shock_3rd:"90 - 200 J",
      Epinephrine_1mg_10mL_IV: "0.2 mg/2 mL",
      Atropine_IV_IO_ETT:"0.4 mg/4 mL",
      Magnesium_sulfate_IV:"850 mg/1.7 mL",
      Epinephrine_1mg_1mL_ETT:"2 mg/2 mL",
      Amiodarone_IV:"105 mg/2.1 mL",
      Lidocaine_IV:"20 mg/1 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"2 mcg/min (30 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"10 mcg/min (150 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.2 mg/0.2 mL",
      Diphenhydramine_IV_IM:"20 mg/0.4 mL",
      Famotidine_IV:"10 mg/1 mL",
      Methylprednisolone_IV:"44 mg/0.7 mL",
      
      // Pain
      Fentanyl_IN:"35 mcg/0.7 mL",
      Fentanyl_IV:"20 mcg/0.4 mL",
      Ketorolac_IV:"9 mg/0.3 mL",
      Tylenol_PO:"320 mg/10 mL",
      Ibuprofen_PO:"200 mg/10 mL",

      // Seizure;
      Midazolam_IN:"4.5 mg/0.9 mL",
      Midazolam_IV:"2 mg/0.4 mL",
      Lorazepam_IV:"2 mg/1 mL",
      D10_IV:"63 mL"
    },
    orange: {
      // Airway equipment
      Miller_Blade: "2",
      Mac_Blade: "2-3",
      Airtraq: "2",
      VividTrac: "Adult",
      Endotracheal_Tube_Cuffed:"6",
      LMA:"2.5",
      KingTube:"2.5",
      iGel:"2.5",

      // Airway emergency
      Etomidate_IV_IO:"8 mg/4 mL",
      Ketamine_IV_IO:"50 mg/1 mL",
      Succinylcholine_IV_IO:"50 mg/2.5 mL",
      Rocuronium_IV_IO:"25 mg/2.5 mL",
      Fentanyl_IV_IO: "25 mcg/0.5 mL",
      Midazolam_IV_IO: "2.5 mg/0.5 mL",
      Lorazepam_IV_IO:"2 mg/2 mL",
      Ketamine_IV_IO:"50 mg/1 mL",

      // Cardiac arrest
      shock_1st:"55 J",
      shock_2nd:"110 J",
      shock_3rd:"110 - 200 J",
      Epinephrine_1mg_10mL_IV: "0.25 mg/2.5 mL",
      Atropine_IV_IO_ETT:"0.5 mg/5 mL",
      Magnesium_sulfate_IV:"1 gm/2 mL",
      Epinephrine_1mg_1mL_ETT:"2.5 mg/2.5 mL",
      Amiodarone_IV:"135 mg/2.7 mL",
      Lidocaine_IV:"26 mg/1.3 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"2.7 mcg/min (40 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"10 mcg/min (150 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.3 mg/0.3 mL",
      Diphenhydramine_IV_IM:"25 mg/0.5 mL",
      Famotidine_IV:"13 mg/1.3 mL",
      Methylprednisolone_IV:"50 mg/0.8 mL",
      
      // Pain
      Fentanyl_IN:"40 mcg/0.8 mL",
      Fentanyl_IV:"25 mcg/0.5 mL",
      Ketorolac_IV:"15 mg/0.5 mL",
      Tylenol_PO:"325 mg/1 tab",
      Ibuprofen_PO:"200 mg/1 tab",

      // Seizure;
      Midazolam_IN:"5.5 mg/1.1 mL",
      Midazolam_IV:"2.5 mg/0.5 mL",
      Lorazepam_IV:"2 mg/1 mL",
      D10_IV:"84 mL"
    },
    green: {
      // Airway equipment
      Miller_Blade: "2",
      Mac_Blade: "2-3",
      Airtraq: "2",
      VividTrac: "Adult",
      Endotracheal_Tube_Cuffed:"6.0-6.5",
      LMA:"3",
      KingTube:"3",
      iGel:"2.5-3",

      // Airway emergency
      Etomidate_IV_IO:"10 mg/5 mL",
      Ketamine_IV_IO:"60 mg/1.2 mL",
      Succinylcholine_IV_IO:"60 mg/3 mL",
      Rocuronium_IV_IO:"30 mg/3 mL",
      Fentanyl_IV_IO: "35 mcg/0.7 mL",
      Midazolam_IV_IO: "3.5 mg/0.7 mL",
      Lorazepam_IV_IO:"2 mg/2 mL",
      Ketamine_IV_IO:"60 mg/1.2 mL",

      // Cardiac arrest
      shock_1st:"65 J",
      shock_2nd:"130 J",
      shock_3rd:"130 - 200 J",
      Epinephrine_1mg_10mL_IV: "0.35 mg/3.5 mL",
      Atropine_IV_IO_ETT:"0.5 mg/5 mL",
      Magnesium_sulfate_IV:"1.4 gm/2.8 mL",
      Epinephrine_1mg_1mL_ETT:"2.5 mg/2.5 mL",
      Amiodarone_IV:"175 mg/3.5 mL",
      Lidocaine_IV:"34 mg/1.7 mL",

      // Pressors
      Epinephrine_Norepinephrine_gtt_IV_init_dos:"3.3 mcg/min (50 gtt/min)",
      Epinephrine_Norepinephrine_gtt_IV_max_dos:"10 mcg/min (150 gtt/min)",

      // Anaphylaxis
      Epinephrine_1mg_1mL_IM:"0.3 mg/0.3 mL",
      Diphenhydramine_IV_IM:"35 mg/0.7 mL",
      Famotidine_IV:"17 mg/1.7 mL",
      Methylprednisolone_IV:"63 mg/1 mL",
      
      // Pain
      Fentanyl_IN:"50 mcg/1 mL",
      Fentanyl_IV:"35 mcg/0.7 mL",
      Ketorolac_IV:"18 mg/0.6 mL",
      Tylenol_PO:"325 mg/1 tab",
      Ibuprofen_PO:"200 mg/1 tab",

      // Seizure;
      Midazolam_IN:"7 mg/1.4 mL",
      Midazolam_IV:"3.5 mg/0.7 mL",
      Lorazepam_IV:"2 mg/1 mL",
      D10_IV:"100 mL"
    },
  };

请在第二个页面显示对应体重的剂量。