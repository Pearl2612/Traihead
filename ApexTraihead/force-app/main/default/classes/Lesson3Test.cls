@isTest
public with sharing class Lesson3Test {
  static Map<String, Integer> newMap = new Map<String, Integer>{
    'Opportunity' => 10,
    'Account' => 20,
    'Contact' => 15,
    'Case' => 40
  };
  @isTest
  static void testKeyValueMap(){
    String mapTest = 'Opportunity: 10Account: 20Contact: 15Case: 40';
    String result = Lesson3.keyValueMap(newMap);
    System.debug(result);
    System.assertEquals(mapTest, result, 'Oh no! There is a bug!');
  }

  @isTest
  static void testMaxKey() {
    String maxKey = 'Case';
    String result = lesson3.Max(newMap);
    System.debug('Key có value lớn nhất là: ' + result);
    System.assertEquals(maxKey, result, 'Oh no! There is a bug!');
  }

  @isTest
  static void testMinKey() {
    String minKey = 'Opportunity';
    String result = lesson3.Min(newMap);
    System.debug('Key có value nhỏ nhất là: ' + result);
    System.assertEquals(minKey, result, 'Oh no! There is a bug!');
  }
  @isTest
  static void testOpp() {
    Integer oppKey = 10;
    Integer result = lesson3.Opp(newMap);
    System.debug(result);
    System.assertEquals(oppKey, result, 'Oh no! There is a bug!');
  }
}
