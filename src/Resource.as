package {
  import com.minimalui.resources.StaticResources;

  public class Resource extends StaticResources {
    // Embed simple objects:
    // [Embed(source="../res/meat-icon.png")]
    // [Resource(name="meat-icon")]
    // public var meat:Class;

    // Or parts of one image:
    // [Embed(source="../res/nutrition-icons.png")]
    // [Resource(name="nutrition")]
    // [Part(x=0, y=0, width=35, height=35, name="calories")]
    // [Part(x=35, y=0, width=35, height=35, name="protein")]
    // [Part(x=70, y=0, width=35, height=35, name="fat")]
    // [Part(x=105, y=0, width=35, height=35, name="carbohydrates")]
    // public var nutritions:Class;
  }
}
