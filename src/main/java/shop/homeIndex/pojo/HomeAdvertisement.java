package shop.homeIndex.pojo;
import java.io.Serializable;
import java.util.Date;
import util.pojo.BaseEntity;
/**
 * 首页广告位实体
 * 
 * @author whb
 * @time 20140115
 */
public class HomeAdvertisement extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 1L;
	/**
	 * 图片ID
	 * 
	 */
	private Integer advertisementId;
	/**
	 * 图片
	 * 
	 */
	private String imageUrl;
	/**
	 * 标题
	 * 
	 */
	private String title;
	/**
	 * 简介
	 * 
	 */
	private String synopsis;
	/**
	 * 链接
	 * 
	 */
	private String link;
	/**
	 * 排序
	 * 
	 */
	private Integer sortCode;
	/**
	 * 显示位置
	 * 
	 */
	private Integer showLocation;
	/**
	 * 是否显示
	 * 
	 */
	private Integer isShow;
	/**
	 * 创建时间
	 * 
	 */
	private Date createTime;
	/**
	 * 创建人
	 * 
	 */
	private String publishUser;
	/**
	 * 修改时间
	 * 
	 */
	private Date updateTime;
	/**
	 * 修改人
	 * 
	 */
	private String modifyUser;
	public Integer getAdvertisementId() {
		return advertisementId;
	}
	public void setAdvertisementId(Integer advertisementId) {
		this.advertisementId = advertisementId;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSynopsis() {
		return synopsis;
	}
	public void setSynopsis(String synopsis) {
		this.synopsis = synopsis;
	}
	public Integer getSortCode() {
		return sortCode;
	}
	public void setSortCode(Integer sortCode) {
		this.sortCode = sortCode;
	}
	public Integer getShowLocation() {
		return showLocation;
	}
	public void setShowLocation(Integer showLocation) {
		this.showLocation = showLocation;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getPublishUser() {
		return publishUser;
	}
	public void setPublishUser(String publishUser) {
		this.publishUser = publishUser;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getModifyUser() {
		return modifyUser;
	}
	public void setModifyUser(String modifyUser) {
		this.modifyUser = modifyUser;
	}
}
