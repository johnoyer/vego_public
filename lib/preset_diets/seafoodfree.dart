import 'package:vego_flutter_project/diet_classes/diet_class.dart';

class SeaFoodFree extends PresetDietWithSubdiets {

  SeaFoodFree()
      : super(
          name: 'Seafood-Free',
          dietInfo: '(from the website) Crustacean shellfish are one of the eight major allergens that must be listed in plain language on'
                    ' packaged foods sold in the U.S., as required by federal law, either within the ingredient list or'
                    ' in a separate “Contains” statement on the package. For crustacean shellfish, the specific variety'
                    ' must also be identified on the package such as crab or shrimp.'
                    ' Mollusks are not required to be labeled in the U.S. at this time and may be present in a food item unexpectedly.'
                    ' This list includes both crustacean shellfish and mollusks.',
          isProhibitive: true,
          isChecked: false,
          hidden: false,
          primaryItems: prohibitedItemsList,
          secondaryItems: possiblyProhibitedItemsList,
          primarySubDietNameToListMap: primarySubDietNameToListMapLocal,
          secondarySubDietNameToListMap: secondarySubDietNameToListMapLocal
        );

  static Map<String,List<String>> primarySubDietNameToListMapLocal = {//need to change all below todo
    'Crustacean Shellfish-Free': [
      'Barnacle', 
      'Crab',
      'Crawfish',
      'crawdad',
      'crayfish',
      'ecrevisse',
      'Krill',
      'Lobster',
      'langouste',
      'langoustine', 
      'Moreton bay bugs', 
      'tomalley',
      'Prawns',
      'Shrimp',
      'Shrimp scampi',
      'scampi',
      'Shrimp crevette',
      'crevette'
    ],
    'Mollusk-Free': [
      'Abalone',
      'Clam',
      'cherrystone clam', 
      'geoduck clam', 
      'littleneck clam', 
      'pismo clam', 
      'quahog clam',
      'surf clam',
      'Cockle',
      'Conch',
      'Cuttlefish',
      'Limpet',
      'lapas', 
      'Loco',
      'opihi',
      'Mollusks',
      'Mussels',
      'Nautilus',
      'Octopus',
      'Oysters',
      'Periwinkle',
      'Sea cucumber',
      'Sea urchin',
      'Scallop',
      'Bay Scallop',
      'Sea Scallop',
      'Snail',
      'escargot',
      'Squid',
      'calamari',
      'Whelk',
      'Turban shell'
    ],
    'Roe-Free': [
      'Caviar',
      'sturgeon roe', 
      'Ikura',
      'salmon roe',
      'Kazunoko', 
      'herring roe',
      'Lumpfish roe',
      'Masago', 
      'capelin roe',
      'Shad roe',
      'Tobiko',
      'flying-fish roe',
      'Uni',
      'Sea Urchin roe'
    ],
    'Fish-Free': [
      'Anchovies',
      'Anglerfish',
      'Barracuda',
      'Basa',
      'Bass',
      'striped bass',
      'Black cod',
      'Bluefish',
      'Bombay duck',
      'Bonito',
      'Bream',
      'Brill',
      'Burbot',
      'Catfish',
      'Cod',
      'Pacific cod',
      'Atlantic cod',
      'Dogfish',
      'Dorade',
      'Eel',
      'Fish',
      'Flounder',
      'Grouper',
      'Haddock',
      'Hake',
      'Halibut',
      'Herring',
      'Ilish',
      'John Dory',
      'Lamprey',
      'Lingcod',
      'Common ling',
      'Mackerel',
      'Horse mackerel',
      'Mahi Mahi',
      'Monkfish',
      'Mullet',
      'Orange roughy',
      'Pacific rudderfish',
      'Japanese butterfish',
      'Pacific saury',
      'Parrotfish',
      'Patagonian toothfish',
      'Chilean sea bass',
      'Perch',
      'Pike',
      'Pollock',
      'Pomfret',
      'Pompano',
      'Pufferfish',
      'Fugu',
      'Sablefish',
      'Sanddab',
      'Pacific sanddab',
      'Sardine',
      'Sea bass',
      'Sea bream',
      'Shad',
      'alewife',
      'American shad',
      'Shark',
      'Skate',
      'Smelt',
      'Snakehead',
      'Snapper',
      'rockfish',
      'rock cod',
      'Pacific snapper',
      'Sole',
      'Sprat',
      'Stromateidae',
      'butterfish',
      'Sturgeon',
      'Surimi',
      'Swordfish',
      'Tilapia',
      'Tilefish',
      'Trout',
      'rainbow trout',
      'Tuna',
      'albacore tuna',
      'yellowfin tuna',
      'bigeye tuna',
      'bluefin tuna',
      'dogtooth tuna',
      'Turbot',
      'Wahoo',
      'Whitefish',
      'stockfish',
      'Whiting',
      'Witch',
      'righteye flounder',
      'Yellowtail',
      'Japanese amberjack'
    ],
  };

  static Map<String,List<String>> secondarySubDietNameToListMapLocal = {
    'Crustacean Shellfish-Free': [
      'Cuttlefish ink',
      'Surimi',
      'Seafood flavoring',
      'Fish stock',
      'fish sauce',
      'Bouillabaisse',
      'Glucosamine'
    ],
    'Mollusk-Free': [
      'Surimi',
      'Seafood flavoring',
      'Fish stock',
      'fish sauce',
      'Bouillabaisse',
      'Glucosamine'
    ],
    'Roe-Free': [],
    'Fish-Free': []
  };

  static List<String> prohibitedItemsList = [
    // Crustacean Shellfish (Shellfish)
    'Barnacle', 
    'Crab',
    'Crawfish',
    'crawdad',
    'crayfish',
    'ecrevisse',
    'Krill',
    'Lobster',
    'langouste',
    'langoustine', 
    'Moreton bay bugs', 
    'tomalley',
    'Prawns',
    'Shrimp',
    'Shrimp scampi',
    'scampi',
    'Shrimp crevette',
    'crevette',
    // Mollusks (Shellfish)
    'Abalone',
    'Clam',
    'cherrystone clam', 
    'geoduck clam', 
    'littleneck clam', 
    'pismo clam', 
    'quahog clam',
    'surf clam',
    'Cockle',
    'Conch',
    'Cuttlefish',
    'Limpet',
    'lapas', 
    'Loco',
    'opihi',
    'Mollusks',
    'Mussels',
    'Nautilus',
    'Octopus',
    'Oysters',
    'Periwinkle',
    'Sea cucumber',
    'Sea urchin',
    'Scallop',
    'Bay Scallop',
    'Sea Scallop',
    'Snail',
    'escargot',
    'Squid',
    'calamari',
    'Whelk',
    'Turban shell',
    // Roe
    'Caviar',
    'sturgeon roe', 
    'Ikura',
    'salmon roe',
    'Kazunoko', 
    'herring roe',
    'Lumpfish roe',
    'Masago', 
    'capelin roe',
    'Shad roe',
    'Tobiko',
    'flying-fish roe',
    'Uni',
    'Sea Urchin roe',
    // Fish
    'Fish',
    'Anchovies',
    'Anglerfish',
    'Barracuda',
    'Basa',
    'Bass',
    'striped bass',
    'Black cod',
    'Bluefish',
    'Bombay duck',
    'Bonito',
    'Bream',
    'Brill',
    'Burbot',
    'Catfish',
    'Cod',
    'Pacific cod',
    'Atlantic cod',
    'Dogfish',
    'Dorade',
    'Eel',
    'Flounder',
    'Grouper',
    'Haddock',
    'Hake',
    'Halibut',
    'Herring',
    'Ilish',
    'John Dory',
    'Lamprey',
    'Lingcod',
    'Common ling',
    'Mackerel',
    'Horse mackerel',
    'Mahi Mahi',
    'Monkfish',
    'Mullet',
    'Orange roughy',
    'Pacific rudderfish',
    'Japanese butterfish',
    'Pacific saury',
    'Parrotfish',
    'Patagonian toothfish',
    'Chilean sea bass',
    'Perch',
    'Pike',
    'Pollock',
    'Pomfret',
    'Pompano',
    'Pufferfish',
    'Fugu',
    'Sablefish',
    'Sanddab',
    'Pacific sanddab',
    'Sardine',
    'Sea bass',
    'Sea bream',
    'Shad',
    'alewife',
    'American shad',
    'Shark',
    'Skate',
    'Smelt',
    'Snakehead',
    'Snapper',
    'rockfish',
    'rock cod',
    'Pacific snapper',
    'Sole',
    'Sprat',
    'Stromateidae',
    'butterfish',
    'Sturgeon',
    'Surimi',
    'Swordfish',
    'Tilapia',
    'Tilefish',
    'Trout',
    'rainbow trout',
    'Tuna',
    'albacore tuna',
    'yellowfin tuna',
    'bigeye tuna',
    'bluefin tuna',
    'dogtooth tuna',
    'Turbot',
    'Wahoo',
    'Whitefish',
    'stockfish',
    'Whiting',
    'Witch',
    'righteye flounder',
    'Yellowtail',
    'Japanese amberjack',
    'Fish stock',
    'fish sauce',
    'Surimi',
    // Other
    'Jellyfish',
    'Sea squirt',
    'Microcosmus sabatieri',
    'sea fig',
    'violet',
    'Pyura chilensis',
    'piure',
    'Halocynthia roretzi',
    'sea pineapple'
  ];
  static List<String> possiblyProhibitedItemsList = [
    // Various
    'Cuttlefish ink',
    'Seafood flavoring',
    'Bouillabaisse',
    'Glucosamine',
    // Seaweed
    'Seaweed'
  ];
}  