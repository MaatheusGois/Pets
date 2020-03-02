package Features;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@CucumberOptions(glue= {"StepsCucumber"},
plugin = {"pretty", "html:target/"}, 
monochrome = true, /*tira os caracteres doidos que s�o usados para colorir a saida em ASCII*/
tags = {"@3030"}) /*Indica qual cenario da feature quero executar */

public class Runner {

}
