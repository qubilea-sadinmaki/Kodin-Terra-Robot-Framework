from robot.api import logger


class ShoppingCartClass:
    """
    Class for caching up actions made in shoppingcart. 
    You can save and restore products, prices, saldo etc.
    This class is a singleton (there can be only one at a time)
    """
    __instance = None
    __saldo = 0
    __deliveryCost = 0
    __totalCost = 0
    __products = []
    name = 'ShoppingCart'

# singleton code --------------------------------
    @staticmethod
    def getInstance():
        """ Static access method. """
        if ShoppingCartClass.__instance is None:
            ShoppingCartClass()
        return ShoppingCartClass.__instance

    def __init__(self):
        """ Virtually private constructor. """
        if ShoppingCartClass.__instance is not None:
            raise Exception("This class is a singleton!")
        else:
            ShoppingCartClass.__instance = self
            self.init()
# singleton code END -----------------------------

    def init(self, test=False):
        self.reset()
        if test:
            self.__dev_init()

# This is just for internal testing
    def __dev_init(self):
        self.addProductToList('product1', '6,66', 1, 'kpl', True)
        self.addProductToList('product2', '3.33', 2, 'kpl', True)
        # last = self.lastProduct
        logger.console("Last product:" + self.lastProduct['name'])
        logger.console("First product:" + self.getProduct(0)['name'])
        logger.console("Count of products:" + str(self.countOfProducts))
        logger.console("Saldo:" + str(self.saldo))
        self.deliveryCost = 9.99
        logger.console("Delivery Cost:" + str(self.deliveryCost))
        logger.console("Total saldo:" + str(self.totalSaldo))
        logger.console("Saldo as string:" + self.getSaldoAsString(','))
        logger.console("Total saldo as string:" + self.getTotalSaldoAsString(','))

    def reset(self):
        self.__products = []
        self.__saldo = 0

    def __newProduct(self, pname, pprice, pcount, ptotal, punit):
        if punit is None or punit == "":
            punit = 'kpl'
        return {'name': pname, 'price': pprice, 'count': pcount,
                'total_price': ptotal, 'unit': punit}

    def addProductToList(self, product, price, count, unit, log=False):
        fprice = float(price.replace(",", "."))
        price_total = int(count) * round(fprice, 2)
        new_product = self.__newProduct(product, price, count,
                                        price_total, unit)
        self.__products.append(new_product)
        self.__saldo += price_total
        if log:
            logger.console("Product:" + product + " price:" + str(fprice) +
                           " count:" + str(count) + " price_total:"
                           + str(price_total) +
                           " unit:" + unit)

    def removeProductFromList(self, log=False, index=-1):
        if(len(self.__products) == 0):
            logger.console("\033[31mTrying to remove from empty shoppingcart!!")

        if(index == -1):
            removedProduct = self.__products.pop()
        else:
            removedProduct = self.__products.pop(index)

        price = float(removedProduct['price'].replace(",", "."))
        self.__saldo -= int(removedProduct['count']) * round(price, 2)

        if log:
            logger.console("Removed product:" + removedProduct['name'])

# getters / setters ---------------------------------------------------------
# # Get totalCost (products + delivery cost)
#     def __get_totalCost(self):
#         return self.__totalCost

#     totalCost = property(__get_totalCost, """get totalCost
#  (products+delivery)""")

# Get / set delivery cost
    def __get_deliveryCost(self):
        return self.__deliveryCost

    def __set_deliveryCost(self, var):
        if type(var) is str:
            var = float(var.replace(",", "."))

        self.__deliveryCost = var

    deliveryCost = property(__get_deliveryCost, __set_deliveryCost,
                            """get/set delivery cost""")

# Get saldo
    def __get_saldo(self):
        return self.__saldo

    saldo = property(__get_saldo, """get saldo (only products)""")

# Get saldo + delivery
    def __get_totalSaldo(self):
        return self.__saldo + self.__deliveryCost

    totalSaldo = property(__get_totalSaldo, """get saldo + delivery""")

# Get last product on list
    def __get_lastProduct(self):
        index = len(self.__products) - 1
        return self.__products[index]

    lastProduct = property(__get_lastProduct, """last product on list""")

# Get count of products
    def __get_countOfProducts(self):
        return len(self.__products)

    countOfProducts = property(__get_countOfProducts, """count of products""")

# Get product on index
    def getProduct(self, index):
        return self.__products[index]

# Get current saldo as string with chosen separator
    def getSaldoAsString(self, withSeparator=''):
        retVal = str(round(self.__saldo, 2))
        if withSeparator != '':
            return retVal.replace('.', withSeparator)
        else:
            return retVal

# Get total saldo as string with chosen separator
    def getTotalSaldoAsString(self, withSeparator=''):
        retVal = str(round(self.totalSaldo, 2))
        if withSeparator != '':
            return retVal.replace('.', withSeparator)
        else:
            return retVal

# Get delivery cost as string with chosen separator
    def getDeliveryCostAsString(self, withSeparator=''):
        retVal = str(round(self.deliveryCost, 2))
        if withSeparator != '':
            return retVal.replace('.', withSeparator)
        else:
            return retVal


class ShoppingCartProductIDs:
    """
    Class contains keyword id's for product-object id/value pair
    """
    NAME = 'name'
    PRICE = 'price'
    COUNT = 'count'
    TOTAL_PRICE = 'total_price'
    UNIT = 'unit'
    # name = ''
    # price = 0
    # count = 0
    # totalPrice = 0
    # unit = ''

    # def __init__(self, name, price, count, total, unit):
    #     if unit is None or unit == "":
    #         unit = 'kpl'

    #     self.name = name
    #     self.price = price
    #     self.count = count
    #     self.totalPrice = total
    #     self.unit = unit

