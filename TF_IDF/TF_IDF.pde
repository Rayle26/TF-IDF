import java.util.*;
import java.io.*; 

Words[] wordData;

File[] files;

Links[] enlace;

String sourceFile = "texts/"; //directory of texts

String[] erase;
String[] nums = {"1","2","3","4","5","6","7","8","9","0"}; // to remove digits from the texts
String[] theWord;
String[] allTheWords;
String[][] textWords;
int[] times;

String[] fileName;
int numFiles;
int textoSelec = 0;

String[][] textWordsPerTxt;
int[][] timesPerTxt;

int[] resultTable;

int[] resultTableTextVal;


PFont font;
int sizeOfText = 12; 

void setup() {
  
  size(500, 700);
  font = createFont("SourceCodePro-Regular.ttf", sizeOfText);
  
  erase = loadStrings("stopwords-en.txt");
  String path = dataPath(sourceFile);
  files = listFiles(path); 
  numFiles = files.length;
  String[][] texto = new String[numFiles][0];
  allTheWords = new String[numFiles];
  textWords = new String[numFiles][0];
  IntDict totalDict = new IntDict();
  IntDict[] dictionary = new IntDict[numFiles];
  textWordsPerTxt = new String[numFiles][0];
  timesPerTxt = new int[numFiles][0];
  
  
 //******loads texts from the directory*****//
 
  for (int i = 0; i <numFiles; i ++) {
    texto[i]= loadStrings(sourceFile + files[i].getName());
    allTheWords[i] = join(texto[i], " ").toLowerCase();
  }
  
  //******removes digits*****//
  
  for (int i = 0; i <nums.length; i ++) {
    for(int j = 0; j <allTheWords.length; j ++) {
      allTheWords[j] = allTheWords[j].replaceAll(nums[i], "");
    }
  }
  
  
  for(int i = 0; i < numFiles; i ++) {
    textWords[i] = splitTokens(allTheWords[i], " -,.:;¿?¡!/_\"");
  }
  
  //******counts words******//
  
  for (int i = 0; i <numFiles; i ++) {
    dictionary[i] = new IntDict();
    for(int j = 0; j <textWords[i].length; j ++) {
      dictionary[i].increment(textWords[i][j]);
    }
  }
    
  //******counts words in all the texts******//
  
  for (int i = 0; i <numFiles; i ++) {
    for(int j = 0; j <textWords[i].length; j ++) {
      totalDict.increment(textWords[i][j]); //da el total de una palabra en todos los textos
    }
  }
  
  //******removes junk words******//
  
    for(int i = 0; i <erase.length; i ++) {
      if(totalDict.hasKey(erase[i]) == true)
      totalDict.remove(erase[i]);
        for(int j = 0; j < numFiles; j ++) {
          if(dictionary[j].hasKey(erase[i]) == true)
          dictionary[j].remove(erase[i]);
          dictionary[j].sortValuesReverse();
        }
  }
    
    theWord = totalDict.keyArray();
    times = totalDict.valueArray();

    for(int i = 0; i <numFiles; i ++) {
      textWordsPerTxt[i] = dictionary[i].keyArray();
      timesPerTxt[i] = dictionary[i].valueArray();
    }
       
   //******document frequency******//     
        
  resultTable = new int [theWord.length];

  for(int j = 0; j <allTheWords.length; j ++) {
    for(int i = 0; i <theWord.length; i ++) {
      if(allTheWords[j].contains(theWord[i]) == true)
      resultTable[i] = resultTable[i] + 1;
    }
  }
  
  //******selects only .txt files******//
    
File Directorio = new File(path);
FilenameFilter ff = new FilenameFilter() {
      public boolean accept(File Directorio, String name) {
         return name.endsWith(".txt");
          }
        };
     fileName = Directorio.list(ff);
     
  //******creates the links to texts******//
     
enlace = new Links[numFiles];
   for (int i = 0; i < fileName.length; i ++) {
     enlace[i] = new Links(60, 68+(sizeOfText*i), textWidth(fileName[i]), sizeOfText, i);
         }
         
      }
  
  
  void draw() {
    
    background(255);
    fill(0);
    textFont(font);
  
 //*****counts the texts where word appears******//   
    
  resultTableTextVal = new int [textWordsPerTxt[textoSelec].length];
  for(int i = 0; i <allTheWords.length; i ++) {
    for (int j = 0; j < textWordsPerTxt[textoSelec].length; j ++) {
        if(allTheWords[i].contains(textWordsPerTxt[textoSelec][0]) == true)
          resultTableTextVal[j] = resultTableTextVal[j] + 1;
      }    
    }
    
  //******the core of the code: creates an object (word) with TF and IDF******//   
    
    int index = 0;
    float idf = 0;
    wordData = new Words[textWordsPerTxt[textoSelec].length];
    for(int i = 0; i< textWordsPerTxt[textoSelec].length; i ++) {
      idf = (float(timesPerTxt[textoSelec][i])/timesPerTxt[textoSelec][0])*log(numFiles/resultTableTextVal[i]); //algoritmo para calcular IDF
      wordData[index++] = new Words(textWordsPerTxt[textoSelec][i],timesPerTxt[textoSelec][i],idf);
    }
      
      //******sorts objects in ascending order******//
      //java.util.Arrays.sort(wordData);
      
      
      //******sorts objects in descending order******//
      Words.isDescent = true;
      java.util.Arrays.sort(wordData);
     
      //******shows the list of texts******//
      
      text("Click to select:", 60, 60);
      for (int i = 0; i < fileName.length; i ++) {
        enlace[i].clickableArea();
        String nombreArchivo = fileName[i].replaceFirst("\\.txt", "");
        pushMatrix();
        translate(60, 80);
        text("- " + nombreArchivo, 0, sizeOfText*i);
        popMatrix();
        }
    
      //******shows the title of text******//
    
        pushMatrix();
        translate(200, 20);
        textAlign(LEFT);
        String titulo = fileName[textoSelec].replaceFirst("\\.txt", "");
        text(titulo, 0, 0); 
        text("Words: " + textWords[textoSelec].length,0, 20);
        popMatrix();
    
      //******shows TF-IDF******//
      
      for(int i = 0; i<wordData.length; i ++ ) {
        pushMatrix();
        translate(200, 60); 
        textAlign(LEFT);
        text(wordData[i].toString(), 0, sizeOfText*i);
        popMatrix();
        }
    
    noLoop();
  }
  
void mousePressed() {
  for (int i = 0; i <numFiles; i ++) {
    if(enlace[i].isHovering){
    textoSelec = enlace[i].textSelector();
    }
  }
    redraw();
}

void mouseMoved() {
  for (int i = 0; i <numFiles; i ++) {
    enlace[i].isInside();
    }
    redraw();
}
