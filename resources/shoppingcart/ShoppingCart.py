from robot.api import logger
from robot.api.deco import keyword
from ShoppingCartClass import ShoppingCartClass, ShoppingCartProductIDs


class ShoppingCart(object):
    """
    A class for Robot Framework keywords.
    Keywords are controlling ShoppingCartClass. 
    This class wprks as a memory for interactions done in shoppingcart.
    """
    __version__ = '0.1'

    def __init__(self):
        ROBOT_LIBRARY_SCOPE = 'TEST'

    @keyword('Init')
    def init(self, name="Ostoskori"):
        """Inits the shoppingcart memory"""
        ShoppingCartClass.getInstance().name = name

    @keyword('Add Product')
    def add_product(self, product, price, count, unit, log=False):
        """Add product to shoppingcart memory"""
        ShoppingCartClass.getInstance().addProductToList(product, price, count,
                                                         unit, log)
    @keyword('Remove Product')
    def remove_product(self, log=False, index=-1):
        """Remove product from shoppingcart memory at index"""
        ShoppingCartClass.getInstance().removeProductFromList(log, index)

    @keyword('Set Delivery Cost')
    def set_delivery_cost(self, cost):
        """Sets delivery cost of shoppingcart memory"""
        ShoppingCartClass.getInstance().deliveryCost = var

    @keyword('Get Delivery Cost')
    def get_delivery_cost(self):
        """Get delivery cost of shoppingcart memory"""
        return ShoppingCartClass.getInstance().deliveryCost

    @keyword('Get Delivery Cost As String')
    def get_delivery_cost(self, withSeparator=''):
        """Get delivery cost of shoppingcart memory as string.\n
        Optionally get the string with separator yoy wish (withSeparator)"""
        return ShoppingCartClass.getInstance().getDeliveryCostAsString(withSeparator='')

    @keyword('Get Saldo')
    def get_saldo(self):
        """Get saldo of shoppingcart memory (products cost sum)."""
        return ShoppingCartClass.getInstance().saldo

    @keyword('Get Saldo As String')
    def get_saldo_as_string(self, withSeparator=''):
        """Get saldo of shoppingcart memory as string.\n
        Optionally get the string with separator yoy wish (withSeparator)."""
        return ShoppingCartClass.getInstance()\
            .getSaldoAsString(withSeparator)

    @keyword('Get Totalsaldo')
    def get_totalsaldo(self):
        """Get total saldo of shoppingcart memory (products + delivery cost)."""
        return ShoppingCartClass.getInstance().totalsaldo

    @keyword('Get Total Saldo As String')
    def get_total_saldo_as_string(self, withSeparator=''):
        """Get total saldo of shoppingcart memory (products + delivery cost).\n
        Optionally get the string with separator yoy wish (withSeparator)"""
        return ShoppingCartClass.getInstance()\
            .getTotalSaldoAsString(withSeparator)

    @keyword('Get Last Product')
    def get_last_product(self):
        """Get last product in shoppingcart memory.\n
        returns: {'name': string, 'price': string, 'count': string,\n
        'total_price': string, 'unit': string}"""
        return ShoppingCartClass.getInstance().lastProduct

    @keyword('Get Last Product Total Price')
    def get_last_product_price(self):
        """Get total price of last product in shoppingcart memory.\n
        Total price is count (of this product) * price (of this product)\n
        returns: string"""
        return ShoppingCartClass.getInstance()\
            .lastProduct[ShoppingCartProductIDs.TOTAL_PRICE]

    @keyword('Get Count Of Products')
    def get_count_of_products(self):
        """Get count of products shoppingcart memory\n
        returns: int"""
        return ShoppingCartClass.getInstance().countOfProducts

    @keyword('Get Product')
    def get_product(self, index):
        """Get product on index in shoppingcart memory.\n
        returns: {'name': string, 'price': string, 'count': string,\n
        'total_price': string, 'unit': string}"""
        return ShoppingCartClass.getInstance().getProduct(index)

    @keyword('Get Product Name')
    def get_product_name(self, index):
        """Get name of product on index in shoppingcart memory.\n
        returns: string"""
        p = ShoppingCartClass.getInstance().getProduct(index)
        return p[ShoppingCartProductIDs.NAME]

    @keyword('Get Product Price')
    def get_product_price(self, index):
        """Get price of (single) product on index in shoppingcart memory.\n
        returns: string"""
        p = ShoppingCartClass.getInstance().getProduct(index)
        return p[ShoppingCartProductIDs.PRICE]

    @keyword('Get Product Count')
    def get_product_count(self, index):
        """Get count of product (how many pieces) on index in shoppingcart memory.\n
        returns: string"""
        p = ShoppingCartClass.getInstance().getProduct(index)
        return p[ShoppingCartProductIDs.COUNT]
