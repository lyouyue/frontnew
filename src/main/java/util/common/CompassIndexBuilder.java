package util.common;
import org.compass.gps.CompassGps;
import org.springframework.beans.factory.InitializingBean;
/**
 * 通过quartz定时调度定时重建索引或自动随Spring ApplicationContext启动而重建索引的Builder.
 * 会启动后延时数秒新开线程调用compassGps.index()函数.
 * 默认会在Web应用每次启动时重建索引,可以设置buildIndex属性为false来禁止此功能.
 * 也可以不用本Builder, 编写手动调用compassGps.index()的代码.
 *
 */
public class CompassIndexBuilder implements InitializingBean {   
    // 是否需要建立索引，可被设置为false使本Builder失效.
    private boolean buildIndex = false;
    // 索引操作线程延时启动的时间，单位为秒
    private int lazyTime = 20;
    // Compass封装
    private CompassGps compassGps;
    // 索引线程
    private Thread indexThread = new Thread() {
        public void run() {
            try {
                Thread.sleep(lazyTime * 1000);
//                System.out.println("Compass 建立索引开始...");
//                long beginTime = System.currentTimeMillis();
                // 重建索引.
                // 如果compass实体中定义的索引文件已存在，索引过程中会建立临时索引，
                // 索引完成后再进行覆盖.
                compassGps.index();
//                long costTime = System.currentTimeMillis() - beginTime;
//                System.out.println("Compass 建立索引完成.");
//                System.out.println("总共耗时： " + costTime + " 毫秒");
            } catch (InterruptedException e) {
                //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
            }
        }
    };
    /**
     * 实现<code>InitializingBean</code>接口，在完成属性注入后调用启动索引线程.
     *
     * @see org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
     */
    public void afterPropertiesSet() throws Exception {
        if (buildIndex) {
            indexThread.setDaemon(true);//设置成后台线程
            indexThread.setName("Compass Indexer");
            indexThread.start();
        }
    }
    public void setBuildIndex(boolean buildIndex) {
        this.buildIndex = buildIndex;
    }
    public void setLazyTime(int lazyTime) {
        this.lazyTime = lazyTime;
    }
    public void setCompassGps(CompassGps compassGps) {
        this.compassGps = compassGps;
    }
}
