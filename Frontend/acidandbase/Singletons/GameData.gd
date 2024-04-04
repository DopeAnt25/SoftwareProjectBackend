extends Node



var tower_data = {
	"gunt1":{
		"damage": 1,
		"fire_rate": 1.0,
		"range": 450,
		"cost": 20,
		"category": "projectile"
	},
	
	"missilet1":{
		"damage": 100,
		"fire_rate": 3.0,
		"range": 550,
		"cost": 45,
		"category": "missile"
	},
	
	"doubleshootert1":{
		"damage": 2,
		"fire_rate": 1.5,
		"range": 220,
		"cost": 60,
		"category": "projectile"
	},
	
	"tripleshootert1":{
		"damage": 6,
		"fire_rate": 2,
		"range": 450,
		"cost": 150,
		"category": "projectile"
	}
}



var questions = {
	##
	## ACID | Base | POLYATOMIC | Neither Questions
	##
	"1":{
		"Question": "What is BaCrO\u2084?",
		"Answer": "Salt",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"2":{
		"Question": "What is AgCl?",
		"Answer": "Neither",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Salt",
			"4": "Neither"
		}
	},

	"3":{
		"Question": "What is CCl\u2084?",
		"Answer": "Neither",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"4":{
		"Question": "What is HCLO\u2084?",
		"Answer": "Acid",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Noble Gas"
		}
	},

	"5":{
		"Question": "What is HNO\u2082?",
		"Answer": "Acid",
		"Options": {
			"1": "Base",
			"2": "Acid",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"6":{
		"Question": "What is C\u2083H\u2088",
		"Answer": "Neither",
		"Options": {
			"1": "Acid",
			"2": "Salt",
			"3": "Neither",
			"4": "Base"
		}
	},

	"7":{
		"Question": "What is CH\u2083COOH?",
		"Answer": "Acid",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"8":{
		"Question": "What is MgC\u2082O\u2084?",
		"Answer": "Base",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"9":{
		"Question": "What is HCN?",
		"Answer": "Acid",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"10":{
		"Question": "What is CH\u2084",
		"Answer": "Neither",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"11":{
		"Question": "What is CaCO\u2083?",
		"Answer": "Base",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"12":{
		"Question": "What is K\u2082SO\u2083",
		"Answer": "Base",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"13":{
		"Question": "What is NO\u2083",
		"Answer": "Polyatomic",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"14":{
		"Question": "What is SO\u2084",
		"Answer": "Polyatomic",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	"15":{
		"Question": "What is NO\u2082",
		"Answer": "Polyatomic",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},

	##
	## BALANCE EQUATIONS
	##
	"16":{
		"Question": "What is the products and balance for the acid-base equation KNO\u2082 (aq) + HClO\u2084 (aq) \u2192 ?",
		"Answer": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq)",
		"Options": {
			"1": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq)",
			"2": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq) + H\u2082O (l)",
			"3": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq) + H\u2082O (l) + O\u2082 (g)",
			"4": "No Reaction"
		}
	},

	"17":{
		"Question": "What is the products and balance for the acid-base equation KNO\u2083 (aq) + HClO\u2084 (aq) \u2192",
		"Answer": "No Reaction",
		"Options": {
			"1": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq)",
			"2": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq) + H\u2082O (l)",
			"3": "HNO\u2082 (aq) + K (aq) + ClO\u2084 (aq) + H\u2082O (l) + O\u2082 (g)",
			"4": "No Reaction"
		}
	},

	"18":{
		"Question": "What is the products and balance for the acid-base equation HCl (aq) + H\u2082O (l) \u2192",
		"Answer": "H\u2083O\u2084 (aq) + Cl (aq)",
		"Options": {
			"1": "H\u2083O\u2084 (aq) + Cl (aq) + O\u2082 (g)",
			"2": "H\u2083O\u2084 (aq) + Cl (aq)",
			"3": "H\u2083O\u2084 (aq) + Cl (aq) + O\u2082 (g) + H\u2082O (l)",
			"4": "No Reaction"
		}
	},

	"19":{
		"Question": "What is the products and balance for the acid-base equation HCN (aq) + H\u2082O (l) \u2192",
		"Answer": "H\u2083O (aq) + CN (aq)",
		"Options": {
			"1": "H\u2083O (aq) + CN (aq) + O\u2082 (g)",
			"2": "H\u2083O (aq) + CN (aq)",
			"3": "H\u2083O (aq) + CN (aq) + O\u2082 (g) + H\u2082O (l)",
			"4": "No Reaction"
		}
	},

	"20":{
		"Question": "What is the products and balance for the acid-base equation KClO\u2084 (aq) + HBr (aq) \u2192",
		"Answer": "No Reaction",
		"Options": {
			"1": "HClO\u2084 (aq) + KBr (aq)",
			"2": "HClO\u2084 (aq) + KBr (aq) + H\u2082O (l)",
			"3": "HClO\u2084 (aq) + KBr (aq) + H\u2082O (l) + O\u2082 (g)",
			"4": "No Reaction"
		}
	},
	"21":{
		"Question": "What is CH\u2083-NH\u2082",
		"Answer": "Base",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	"22":{
		"Question": "What is Mg(OH)\u2082",
		"Answer": "Base",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	"23":{
		"Question": "What is HCl",
		"Answer": "Acid",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	"24":{
		"Question": "What is HNO\u2083",
		"Answer": "Acid",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	"25":{
		"Question": "What is K\u2083PO\u2084",
		"Answer": "Base",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	"26":{
		"Question": "What is KNO\u2083",
		"Answer": "Neither",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	"27":{
		"Question": "What is KNO\u2082",
		"Answer": "Neither",
		"Options": {
			"1": "Acid",
			"2": "Base",
			"3": "Polyatomic",
			"4": "Neither"
		}
	},
	
	
}
