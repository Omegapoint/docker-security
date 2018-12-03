public class DockerTest {
  public static void main(String[] args) throws InterruptedException {
    Runtime runtime = Runtime.getRuntime();
    int  cpus = runtime.availableProcessors();
    long mmax = runtime.maxMemory() / 1024 / 1024;
    System.out.println("System properties");
    System.out.println("Cores       : " + cpus);
    System.out.println("Memory (Max): " + mmax);
    while (true) Thread.sleep(1000);
  }
}