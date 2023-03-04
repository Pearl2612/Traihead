public class lesson3 {
  public static String keyValueMap(Map<String, Integer> input) {
    String result = '';
    for(String key : input.keySet()) {
      result += key + ': ' + input.get(key);
    }
    return result;
  }
  
  public static String Max(Map<String,Integer> input) {
    String maxKey = '';
    Integer maxValue = 0;
    for(String key : input.keySet()) {
      Integer value = input.get(key);
      if(value > maxValue) {
        maxValue = value;
        maxKey = key;
      }
    }
    return maxKey;
  }
  public static String Min(Map<String, Integer> input) {
    String minKey = '';
    Integer minValue = 0;
    for (String key : input.keySet()) {
      Integer value = input.get(key);
      if (minKey == '' || value < minValue) {
        minValue = value;
        minKey = key;
      }
    }
    return minKey;
  }
  public static Integer Opp(Map<String, Integer> input) {
    Integer opp = input.get('Opportunity');
    return opp;
  }
}
