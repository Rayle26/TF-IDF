static class Words implements Comparable<Words> {

   static boolean isDescent;
   
   String whichFile;
   String word;
   Integer frequency;
   float inversFreq;
  
  Words(String word_, Integer frequency_, float inversFreq_) {
    word = word_;
    frequency = frequency_;
    inversFreq = inversFreq_;
  }
  
  @ Override int compareTo(Words c) {
    return Float.compare(inversFreq, c.inversFreq) * (isDescent? -1 : 1);
  }

  @ Override String toString() {
    return word + " (TF: " + frequency + ", " + "IDF: " + inversFreq + ")";
  }
  
}
