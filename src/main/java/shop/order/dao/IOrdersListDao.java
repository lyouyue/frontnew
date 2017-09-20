package shop.order.dao;
import shop.order.pojo.OrdersList;
import util.dao.IBaseDao;
/**
 * 订单明细dao层接口类
 * @author 张攀攀
 *
 */
public interface IOrdersListDao extends IBaseDao<OrdersList>{
    /**
     * 根据订单号查询订单详情
     *
     * @param ordersNo
     * @return
     * @throws Exception
     */
    public OrdersList getOrdersListByOrdersNo(String ordersNo);
}
