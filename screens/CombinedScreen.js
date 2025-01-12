import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, TextInput, Image, Alert } from 'react-native';
import SegmentedControl from '@react-native-segmented-control/segmented-control';

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

// dosage数据
const dosageData = [
  {"name":"Epinephrine 1 mg/10 mL (IV)", "dosagePerKg": 0.01, "concentration (mg/mL)": 0.1},
  {"name":"Fentanyl (IV, IO)", "dosagePerKg": 0.001, "concentration (mg/mL)": 0.05},
  {"name":"Midazolam (IN)", "dosagePerKg": 0.2, "concentration (mg/mL)": 5},
];

export default function CombinedScreen({ navigation }) {
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [weight, setWeight] = useState('');
  const [height, setHeight] = useState('');
  const [weightUnit, setWeightUnit] = useState('kg');
  const [heightUnit, setHeightUnit] = useState('cm');


  // 单位转换函数
  const convertWeightToKg = (value, unit) => (unit === 'lb' ? value * 0.453592 : value);
  const convertHeightToCm = (value, unit) => (unit === 'in' ? value * 2.54 : value);

  // 根据 Height 从 JSON 表格估算 Weight
  const estimateWeightFromHeight = (heightCm) => {
    const entry = heightWeightData.find(
      (item) => heightCm > item.height_min && heightCm <= item.height_max
    );
    return entry ? entry.weight : null;
  };

  // 根据 Weight 从 JSON 表格计算剂量
  const calculateDosageForWeight = (weightKg) => {
    return dosageData.map(medication => {
      const concentration = medication['concentration (mg/mL)'];
      const dosage = (medication.dosagePerKg * weightKg) / concentration;
      return {
        medication: medication.name,
        dosagePerKg: medication.dosagePerKg,
        concentration: concentration,
        weight: weightKg,
        calculatedVolume: dosage.toFixed(2) + ' ml',
      };
    });
  };
  
  // 测试测试测试测试
  //   const weight = 36; // patient's weight in kg
  // const dosages = calculateDosageForWeight(weight);

  // // Display results
  // dosages.forEach(dosageInfo => {
  //   console.log(`Medication: ${dosageInfo.medication}`);
  //   console.log(`  Dosage per kg: ${dosageInfo.dosagePerKg} mg/kg`);
  //   console.log(`  Concentration: ${dosageInfo.concentration} mg/mL`);
  //   console.log(`  Patient weight: ${dosageInfo.weight} kg`);
  //   console.log(`  Calculated volume: ${dosageInfo.calculatedVolume}`);
  //   console.log('----------------------------');
  // });

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
      Fentanyl: "20 mcg/0.4mL",
      Midazolam: "2 mg/0.4mL",
      Epinephrine: "0.2 mg/2mL",
    },
    orange: {
      Fentanyl: "25 mcg/0.5mL",
      Midazolam: "2.5 mg/0.5mL",
      Epinephrine: "0.25 mg/2.5mL",
    },
    green: {
      Fentanyl: "35 mcg/0.7mL",
      Midazolam: "3.5 mg/0.7mL",
      Epinephrine: "0.35 mg/3.5mL",
    },
  };

  // 处理 Finish 按钮点击事件
  const handleFinish = () => {
    if (!weight && !height) {
      Alert.alert('Error', 'Please input either weight or height.');
      return;
    }

    let finalWeight = null;

    if (weight) {
      finalWeight = parseFloat(weight) * (weightUnit === 'lb' ? 0.453592 : 1);
    } else if (height) {
      const convertedHeight = parseFloat(height) * (heightUnit === 'in' ? 2.54 : 1);
      const matchedEntry = heightWeightData.find(
        (entry) => convertedHeight >= entry.height_min && convertedHeight < entry.height_max
      );

      if (matchedEntry) {
        finalWeight = matchedEntry.weight;
      } else {
        Alert.alert('Error', 'Unable to estimate weight from the given height.');
        return;
      }
    }

    navigation.navigate('Result', { finalWeight });
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.tutorialLogo}
        onPress={() => navigation.navigate('Guide')}
      >
        <Image source={require('../assets/tutorial.png')} style={styles.logo} />
      </TouchableOpacity>

      <View style={styles.content}>
        <Text style={styles.title}>Welcome to AccuWeight2Dose</Text>

        <SegmentedControl
          values={['Camera', 'Manual Input']}
          selectedIndex={selectedIndex}
          onChange={(event) => setSelectedIndex(event.nativeEvent.selectedSegmentIndex)}
          style={styles.segmentedControl}
        />

        {selectedIndex === 0 && (
          <View style={styles.cameraContainer}>
            <Text style={styles.infoText}>Use Camera to Measure Height</Text>
            <TouchableOpacity style={styles.button}>
              <Text style={styles.buttonText}>Open Camera</Text>
            </TouchableOpacity>
          </View>
        )}

        {selectedIndex === 1 && (
          <View style={styles.manualInputContainer}>
            <Text style={styles.label}>Weight (recommended):</Text>
            <View style={styles.inputRow}>
              <TextInput
                style={styles.input}
                placeholder="Enter weight"
                keyboardType="numeric"
                value={weight}
                onChangeText={setWeight}
              />
              <SegmentedControl
                values={['kg', 'lb']}
                selectedIndex={weightUnit === 'kg' ? 0 : 1}
                onChange={(event) =>
                  setWeightUnit(event.nativeEvent.selectedSegmentIndex === 0 ? 'kg' : 'lb')
                }
                style={styles.unitSelector}
              />
            </View>

            <Text style={styles.label}>Height:</Text>
            <View style={styles.inputRow}>
              <TextInput
                style={styles.input}
                placeholder="Enter height"
                keyboardType="numeric"
                value={height}
                onChangeText={setHeight}
              />
              <SegmentedControl
                values={['cm', 'in']}
                selectedIndex={heightUnit === 'cm' ? 0 : 1}
                onChange={(event) =>
                  setHeightUnit(event.nativeEvent.selectedSegmentIndex === 0 ? 'cm' : 'in')
                }
                style={styles.unitSelector}
              />
            </View>

            <TouchableOpacity style={styles.button} onPress={handleFinish}>
              <Text style={styles.buttonText}>Finish</Text>
            </TouchableOpacity>
          </View>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f9f9f9' },
  tutorialLogo: { position: 'absolute', top: 50, left: 20 },
  logo: { width: 40, height: 40 },
  content: { flex: 1, marginTop: 120, paddingHorizontal: 20 },
  title: { fontSize: 24, fontWeight: 'bold', marginBottom: 20, textAlign: 'center' },
  segmentedControl: { marginBottom: 20 },
  cameraContainer: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  infoText: { fontSize: 18, marginBottom: 20 },
  manualInputContainer: { flex: 1 },
  label: { fontSize: 18, marginBottom: 10 },
  inputRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 20 },
  input: { flex: 1, borderWidth: 1, borderColor: '#ddd', padding: 10, borderRadius: 5 },
  unitSelector: { marginLeft: 10, flex: 0.5 },
  button: { backgroundColor: '#007BFF', padding: 15, borderRadius: 10, alignItems: 'center' },
  buttonText: { color: '#fff', fontSize: 16 },
});
